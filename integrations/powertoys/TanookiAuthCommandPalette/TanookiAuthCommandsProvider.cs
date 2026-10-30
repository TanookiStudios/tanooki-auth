using Microsoft.CommandPalette.Extensions;
using Microsoft.CommandPalette.Extensions.Toolkit;

namespace TanookiAuthCommandPalette;

public partial class TanookiAuthCommandsProvider : CommandProvider
{
    private readonly ICommandItem[] _commands;

    public TanookiAuthCommandsProvider()
    {
        DisplayName = "Tanooki Auth";
        Icon = IconHelpers.FromRelativePath("Assets\\Icon.png");
        _commands = [
            new CommandItem(new SearchCodesPage())
            {
                Title = "Tanooki Auth",
                Subtitle = "Search your two-factor accounts and copy a code",
            },
        ];
    }

    public override ICommandItem[] TopLevelCommands() => _commands;
}
