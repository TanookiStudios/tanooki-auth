// The PowerToys bridge client against the shared fake app (integrations/test/fake-bridge.mjs, run with Node),
// on ports of its own and with an in-memory token, so it never touches the real app or a real token.
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using TanookiBridge;
using Xunit;

namespace TanookiBridge.Tests;

sealed class MemoryTokens : ITokenStore
{
    public string? Token;
    public string? Get() => Token;
    public void Set(string token) => Token = token;
    public void Clear() => Token = null;
}

sealed class FakeApp : IDisposable
{
    readonly Process _node;

    public FakeApp()
    {
        var script = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "test", "fake-bridge-server.mjs"));
        Assert.True(File.Exists(script), $"missing {script}");
        _node = Process.Start(new ProcessStartInfo("node", [script])
        {
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
        })!;
    }

    public string Ask(string command)
    {
        _node.StandardInput.WriteLine(command);
        _node.StandardInput.Flush();
        return _node.StandardOutput.ReadLine() ?? throw new InvalidOperationException("fake app quit");
    }

    public void Dispose()
    {
        _node.Kill();
        _node.Dispose();
    }

    public static int FreePort()
    {
        var l = new TcpListener(IPAddress.Loopback, 0);
        l.Start();
        var port = ((IPEndPoint)l.LocalEndpoint).Port;
        l.Stop();
        return port;
    }
}

public sealed class BridgeClientTests : IDisposable
{
    readonly FakeApp _app = new();
    readonly MemoryTokens _tokens = new();
    readonly int _appPort = FakeApp.FreePort();
    readonly BridgeClient _client;

    public BridgeClientTests()
    {
        // Nothing listens on the first port; the fake app comes and goes on the second.
        _client = new BridgeClient(_tokens, [FakeApp.FreePort(), _appPort]);
    }

    public void Dispose() => _app.Dispose();

    static async Task<BridgeException> Fails(Task t, string code)
    {
        var e = await Assert.ThrowsAsync<BridgeException>(() => t);
        Assert.Equal(code, e.Code);
        return e;
    }

    [Fact]
    public async Task AppNotRunning()
    {
        var e = await Fails(_client.Accounts(), "noApp");
        Assert.Contains("isn't running", e.Message);
    }

    [Fact]
    public async Task AppTooOldToAcceptPowerToys()
    {
        Assert.Equal("STARTED", _app.Ask($"start {_appPort} old"));
        var e = await Fails(_client.Accounts(), "oldApp");
        Assert.Contains("doesn't accept PowerToys yet. Update Tanooki Auth", e.Message);
    }

    [Fact]
    public async Task PairListCopyLockAndUnpair()
    {
        Assert.Equal("STARTED", _app.Ask($"start {_appPort}"));

        var notPaired = await Fails(_client.Accounts(), "notPaired");
        Assert.Equal("PowerToys isn't paired with Tanooki Auth yet.", notPaired.Message);

        // Pairing: a wrong code is refused, then the code the app shows (typed with a space) works.
        Assert.True(await _client.PairStart());
        var code = _app.Ask("paircode").Split(' ')[1];
        await Fails(_client.PairFinish(code == "000000" ? "111111" : "000000"), "wrongCode");
        Assert.True(await _client.PairFinish($"{code[..3]} {code[3..]}"));
        Assert.Matches("^[0-9a-f]{64}$", _tokens.Token);
        Assert.Equal($"TOKEN {_tokens.Token}", _app.Ask("token"));

        // Listing: names and websites only, so no code (and no counter-based code) is spent just by searching.
        var list = await _client.Accounts();
        Assert.Equal(["gh", "aws", "bank"], list.Select(a => a.Id));
        Assert.Equal("GitHub", list[0].Title);
        Assert.Equal("maddie@example.com", list[0].Label);
        Assert.Equal(["github.com"], list[0].Domains);
        Assert.Equal("checking", list[2].Label);

        // Enter: a fresh code at the moment of use.
        Assert.Equal(_app.Ask("code aws").Split(' ')[1], await _client.Code("aws"));
        Assert.Matches("^[0-9]{6}$", await _client.Code("bank"));

        // Search over issuer, name and website.
        Assert.Equal(["gh"], BridgeClient.Search(list, "git maddie").Select(a => a.Id));
        Assert.Equal(["aws"], BridgeClient.Search(list, "AMAZON").Select(a => a.Id));
        Assert.Empty(BridgeClient.Search(list, "nothing-matches"));
        Assert.Equal(3, BridgeClient.Search(list, "  ").Count());

        Assert.Equal("OK", _app.Ask("lock"));
        Assert.Contains("locked", (await Fails(_client.Accounts(), "locked")).Message);
        Assert.Equal("OK", _app.Ask("unlock"));

        // Unpaired in the app: the stored token is dropped and pairing is offered again.
        Assert.Equal("OK", _app.Ask("unpair"));
        await Fails(_client.Accounts(), "notPaired");
        Assert.Null(_tokens.Token);
    }

    [Fact]
    public void GroupsCodes()
    {
        Assert.Equal("123 456", BridgeClient.GroupCode("123456"));
        Assert.Equal("1234 5678", BridgeClient.GroupCode("12345678"));
        Assert.Equal("ABCDE", BridgeClient.GroupCode("ABCDE"));
    }
}
