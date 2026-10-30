using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.CommandPalette.Extensions;
using Microsoft.CommandPalette.Extensions.Toolkit;
using TanookiBridge;
using Windows.ApplicationModel.DataTransfer;

namespace TanookiAuthCommandPalette;

/// <summary>
/// The Tanooki Auth page: search accounts, Enter copies the current code. When PowerToys isn't paired yet,
/// the same page walks through pairing: Enter asks the app for a code, then you type that code in the search box.
/// </summary>
internal sealed partial class SearchCodesPage : DynamicListPage
{
    private readonly BridgeClient _client = new(new CredentialTokenStore());
    private readonly Lock _lock = new();
    private List<Account>? _accounts;
    private BridgeException? _error;
    private string? _pairMessage; // set while the app is showing a pairing code
    private DateTimeOffset _loadedAt;
    private bool _loading;

    public SearchCodesPage()
    {
        Icon = IconHelpers.FromRelativePath("Assets\\Icon.png");
        Title = "Tanooki Auth";
        Name = "Open";
        PlaceholderText = "Search accounts…";
    }

    public override void UpdateSearchText(string oldSearch, string newSearch) => RaiseItemsChanged();

    public override IListItem[] GetItems()
    {
        lock (_lock)
        {
            // Accounts rarely change; ask again after a minute, or straight away after a problem.
            if (!_loading && _pairMessage == null && (_error != null || _accounts == null || DateTimeOffset.UtcNow - _loadedAt > TimeSpan.FromMinutes(1)))
            {
                _loading = true;
                IsLoading = true;
                _ = Task.Run(Load);
            }

            if (_pairMessage != null) return PairingItems();
            if (_error != null) return ErrorItems(_error);
            if (_accounts == null) return [];
            if (_accounts.Count == 0) return [Info("No accounts in Tanooki Auth yet", "Add accounts in the Tanooki Auth app.")];
            var found = BridgeClient.Search(_accounts, SearchText).Select(a => (IListItem)new ListItem(new CopyCodeCommand(_client, a, this))
            {
                Title = a.Title,
                Subtitle = a.Issuer.Length > 0 ? a.Label : string.Empty,
                Tags = a.Domains.Take(1).Select(d => (ITag)new Tag(d)).ToArray(),
            }).ToArray();
            return found.Length > 0 ? found : [Info("No matching accounts", "Try another name or website.")];
        }
    }

    private async Task Load()
    {
        List<Account>? accounts = null;
        BridgeException? error = null;
        try
        {
            accounts = await _client.Accounts();
        }
        catch (BridgeException e)
        {
            error = e;
        }

        lock (_lock)
        {
            _accounts = accounts ?? _accounts;
            _error = error;
            _loadedAt = DateTimeOffset.UtcNow;
            _loading = false;
        }

        IsLoading = false;
        RaiseItemsChanged();
    }

    internal void Reload()
    {
        lock (_lock)
        {
            _accounts = null;
            _error = null;
        }

        RaiseItemsChanged();
    }

    private static ListItem Info(string title, string subtitle) => new(new NoOpCommand()) { Title = title, Subtitle = subtitle };

    private IListItem[] ErrorItems(BridgeException e)
    {
        if (e.Code == "notPaired")
        {
            return [new ListItem(new AnonymousCommand(() => StartPairing()) { Name = "Start pairing", Result = CommandResult.KeepOpen() })
            {
                Title = "Pair with Tanooki Auth",
                Subtitle = "Connect PowerToys to the Tanooki Auth app on this PC. You only do this once. Press Enter to start.",
            }];
        }

        var title = e.Code switch
        {
            "noApp" => "Open Tanooki Auth",
            "locked" => "Unlock Tanooki Auth",
            "oldApp" => "Update Tanooki Auth",
            _ => "Tanooki Auth",
        };
        return [new ListItem(new AnonymousCommand(Reload) { Name = "Try again", Result = CommandResult.KeepOpen() }) { Title = title, Subtitle = e.Message }];
    }

    private void StartPairing()
    {
        string message;
        try
        {
            _client.PairStart().GetAwaiter().GetResult();
            message = "Tanooki Auth is now showing a 6-digit code. Type it in the search box above.";
        }
        catch (BridgeException e)
        {
            lock (_lock) _error = e;
            RaiseItemsChanged();
            return;
        }

        lock (_lock) _pairMessage = message;
        SearchText = string.Empty;
        RaiseItemsChanged();
    }

    private IListItem[] PairingItems()
    {
        var digits = new string(SearchText.Where(char.IsAsciiDigit).ToArray());
        if (digits.Length != 6) return [Info("Type the code from Tanooki Auth", _pairMessage!)];
        return [new ListItem(new AnonymousCommand(() => FinishPairing(digits)) { Name = "Pair", Result = CommandResult.KeepOpen() })
        {
            Title = $"Pair using code {BridgeClient.GroupCode(digits)}",
            Subtitle = "Press Enter to pair.",
        }];
    }

    private void FinishPairing(string code)
    {
        try
        {
            _client.PairFinish(code).GetAwaiter().GetResult();
        }
        catch (BridgeException e)
        {
            lock (_lock)
            {
                // Three wrong codes or a closed dialog end the attempt: offer to start again.
                if (e.Code == "pairing" || e.Code == "noApp") { _pairMessage = null; _error = e; }
                else _pairMessage = e.Message;
            }

            RaiseItemsChanged();
            return;
        }

        lock (_lock) _pairMessage = null;
        SearchText = string.Empty;
        new ToastStatusMessage("PowerToys is paired with Tanooki Auth").Show();
        Reload();
    }
}

/// <summary>Enter on an account: asks the app for the code right now, so it's never one about to expire.</summary>
internal sealed partial class CopyCodeCommand : InvokableCommand
{
    private readonly BridgeClient _client;
    private readonly Account _account;
    private readonly SearchCodesPage _page;

    public CopyCodeCommand(BridgeClient client, Account account, SearchCodesPage page)
    {
        _client = client;
        _account = account;
        _page = page;
        Name = "Copy code";
        Icon = new IconInfo(""); // Copy
    }

    public override ICommandResult Invoke()
    {
        string code;
        try
        {
            code = _client.Code(_account.Id).GetAwaiter().GetResult();
        }
        catch (BridgeException e)
        {
            if (e.Code == "notPaired") _page.Reload();
            return CommandResult.ShowToast(new ToastArgs { Message = $"Couldn't get the code. {e.Message}", Result = CommandResult.KeepOpen() });
        }

        CopyPrivately(code);
        return CommandResult.ShowToast($"Copied {_account.Title} code");
    }

    // Kept out of clipboard history and cloud clipboard: a two-factor code shouldn't be saved anywhere.
    private static void CopyPrivately(string text)
    {
        var thread = new Thread(() =>
        {
            var data = new DataPackage();
            data.SetText(text);
            Clipboard.SetContentWithOptions(data, new ClipboardContentOptions { IsAllowedInHistory = false, IsRoamable = false });
            Clipboard.Flush();
        });
        thread.SetApartmentState(ApartmentState.STA);
        thread.Start();
        thread.Join();
    }
}
