// Talks to the Tanooki Auth desktop app over 127.0.0.1 only, the same way the Raycast extension does
// (integrations/shared/bridge.mjs, app/lib/bridge/server.dart). Never sees a secret, only current codes.
using System.Net.WebSockets;
using System.Text;
using System.Text.Json.Nodes;

namespace TanookiBridge;

public sealed class BridgeException(string code, string message) : Exception(message)
{
    public string Code { get; } = code;
}

/// <summary>Where the pairing token lives. Windows uses Credential Manager; tests use memory.</summary>
public interface ITokenStore
{
    string? Get();
    void Set(string token);
    void Clear();
}

public sealed record Account(string Id, string Type, string Issuer, string Label, IReadOnlyList<string> Domains)
{
    public string Title => Issuer.Length > 0 ? Issuer : Label;
}

public sealed class BridgeClient(ITokenStore tokens, IReadOnlyList<int>? ports = null)
{
    public const string Origin = "tanooki-integration://powertoys";
    public static readonly int[] DefaultPorts = [41984, 41985, 41986, 41987, 41988, 41989, 41990, 41991, 41992, 41993];

    static readonly Dictionary<string, string> Messages = new()
    {
        ["noApp"] = "Tanooki Auth isn't running. Open Tanooki Auth on this PC, then try again.",
        ["oldApp"] = "Tanooki Auth is running but doesn't accept PowerToys yet. Update Tanooki Auth, then try again.",
        ["notPaired"] = "PowerToys isn't paired with Tanooki Auth yet.",
        ["timeout"] = "Tanooki Auth didn't answer in time.",
    };

    static readonly HttpClient Http = new() { Timeout = TimeSpan.FromMilliseconds(400) };
    readonly IReadOnlyList<int> _ports = ports ?? DefaultPorts;

    static BridgeException Err(string code) => new(code, Messages[code]);

    /// <summary>HTTP status the port answers with our Origin (400 = the app, 403 = the app refusing us), or null.</summary>
    static async Task<int?> Probe(int port)
    {
        try
        {
            using var req = new HttpRequestMessage(HttpMethod.Get, $"http://127.0.0.1:{port}/");
            req.Headers.TryAddWithoutValidation("Origin", Origin);
            using var res = await Http.SendAsync(req).ConfigureAwait(false);
            return (int)res.StatusCode;
        }
        catch (Exception e) when (e is HttpRequestException or TaskCanceledException)
        {
            return null;
        }
    }

    async Task<ClientWebSocket> Connect()
    {
        var refused = false;
        foreach (var port in _ports)
        {
            var status = await Probe(port).ConfigureAwait(false);
            if (status == 403) refused = true;
            if (status != 400) continue; // 400 = the app's answer to a plain HTTP request it would accept
            var ws = new ClientWebSocket();
            ws.Options.SetRequestHeader("Origin", Origin);
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
            try
            {
                await ws.ConnectAsync(new Uri($"ws://127.0.0.1:{port}"), cts.Token).ConfigureAwait(false);
            }
            catch (OperationCanceledException)
            {
                ws.Dispose();
                throw Err("timeout");
            }
            catch (WebSocketException)
            {
                ws.Dispose();
                throw Err("noApp");
            }
            return ws;
        }
        throw Err(refused ? "oldApp" : "noApp");
    }

    /// <summary>Opens one connection, runs fn(send), closes it. send() attaches the stored token.</summary>
    async Task<T> Session<T>(Func<Func<JsonObject, Task<JsonObject>>, Task<T>> fn)
    {
        using var ws = await Connect().ConfigureAwait(false);
        var token = tokens.Get();
        var nextId = 1;
        async Task<JsonObject> Send(JsonObject msg)
        {
            var id = nextId++;
            msg["id"] = id;
            if (token != null) msg["token"] = token;
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(10));
            try
            {
                await ws.SendAsync(Encoding.UTF8.GetBytes(msg.ToJsonString()), WebSocketMessageType.Text, true, cts.Token).ConfigureAwait(false);
                while (true)
                {
                    var reply = JsonNode.Parse(await Receive(ws, cts.Token).ConfigureAwait(false)) as JsonObject
                        ?? throw new BridgeException("badReply", "Tanooki Auth sent something unexpected.");
                    if (reply["id"]?.GetValue<int>() != id) continue;
                    if (reply["error"] is JsonNode err) throw new BridgeException(err.GetValue<string>(), reply["message"]?.GetValue<string>() ?? err.GetValue<string>());
                    return reply;
                }
            }
            catch (OperationCanceledException)
            {
                throw Err("timeout");
            }
            catch (WebSocketException)
            {
                throw Err("noApp");
            }
        }
        try
        {
            return await fn(Send).ConfigureAwait(false);
        }
        catch (BridgeException e) when (e.Code == "notPaired")
        {
            tokens.Clear();
            throw Err("notPaired"); // the app's own wording says "This browser"
        }
        finally
        {
            if (ws.State == WebSocketState.Open)
            {
                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(1));
                try { await ws.CloseAsync(WebSocketCloseStatus.NormalClosure, null, cts.Token).ConfigureAwait(false); } catch (Exception) { /* closing anyway */ }
            }
        }
    }

    static async Task<string> Receive(ClientWebSocket ws, CancellationToken ct)
    {
        var buf = new byte[8192];
        using var all = new MemoryStream();
        while (true)
        {
            var r = await ws.ReceiveAsync(buf, ct).ConfigureAwait(false);
            if (r.MessageType == WebSocketMessageType.Close) throw Err("noApp");
            all.Write(buf, 0, r.Count);
            if (r.EndOfMessage) return Encoding.UTF8.GetString(all.ToArray());
        }
    }

    static JsonObject Msg(string type) => new() { ["type"] = type };

    /// <summary>Every live account (names and websites only; codes are fetched one at a time with Code()).</summary>
    public Task<List<Account>> Accounts() => Session(async send =>
        (await send(Msg("accounts")).ConfigureAwait(false))["accounts"]!.AsArray().Select(a => new Account(
            a!["id"]!.GetValue<string>(), a["type"]?.GetValue<string>() ?? "totp", a["issuer"]?.GetValue<string>() ?? "",
            a["label"]?.GetValue<string>() ?? "", a["domains"]?.AsArray().Select(d => d!.GetValue<string>()).ToList() ?? [])).ToList());

    /// <summary>A fresh code for one account at the moment of use (spends one counter-based code).</summary>
    public Task<string> Code(string accountId) => Session(async send =>
    {
        var req = Msg("code");
        req["accountId"] = accountId;
        return (await send(req).ConfigureAwait(false))["code"]!.GetValue<string>();
    });

    /// <summary>Step 1: the app shows a 6-digit code.</summary>
    public Task<bool> PairStart() => Session(async send => { await send(Msg("pair")).ConfigureAwait(false); return true; });

    /// <summary>Step 2: send the code the user typed; stores the token.</summary>
    public Task<bool> PairFinish(string code) => Session(async send =>
    {
        var req = Msg("pair");
        req["code"] = new string(code.Where(char.IsAsciiDigit).ToArray());
        var token = (await send(req).ConfigureAwait(false))["token"]?.GetValue<string>() ?? "";
        if (token.Length == 0 || !token.All(char.IsAsciiHexDigitLower)) throw new BridgeException("badToken", "Tanooki Auth sent an unexpected pairing token.");
        tokens.Set(token);
        return true;
    });

    /// <summary>"123456" -> "123 456", "12345678" -> "1234 5678".</summary>
    public static string GroupCode(string c) => c.Length switch
    {
        6 => $"{c[..3]} {c[3..]}",
        8 => $"{c[..4]} {c[4..]}",
        _ => c,
    };

    /// <summary>Accounts whose name, issuer or website contains every word of the query (any case).</summary>
    public static IEnumerable<Account> Search(IEnumerable<Account> accounts, string query)
    {
        var words = query.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        return accounts.Where(a =>
        {
            var hay = string.Join(' ', [a.Issuer, a.Label, .. a.Domains]);
            return words.All(w => hay.Contains(w, StringComparison.OrdinalIgnoreCase));
        });
    }
}
