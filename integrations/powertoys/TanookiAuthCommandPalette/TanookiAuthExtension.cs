using System;
using System.Runtime.InteropServices;
using System.Threading;
using Microsoft.CommandPalette.Extensions;

namespace TanookiAuthCommandPalette;

// Must match the ClassId in Package.appxmanifest.
[Guid("1D0E5F63-B7E0-461F-ABDA-5891887818C5")]
public sealed partial class TanookiAuthExtension(ManualResetEvent disposed) : IExtension, IDisposable
{
    private readonly TanookiAuthCommandsProvider _provider = new();

    public object? GetProvider(ProviderType providerType) => providerType == ProviderType.Commands ? _provider : null;

    public void Dispose() => disposed.Set();
}
