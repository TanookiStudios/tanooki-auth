using System;
using System.Runtime.InteropServices;
using TanookiBridge;
using Windows.Security.Credentials;

namespace TanookiAuthCommandPalette;

/// <summary>Keeps the pairing token in Windows Credential Manager, never in a file.</summary>
internal sealed class CredentialTokenStore : ITokenStore
{
    private const string Resource = "Tanooki Auth bridge";
    private const string User = "powertoys";
    private readonly PasswordVault _vault = new();

    public string? Get()
    {
        try
        {
            var c = _vault.Retrieve(Resource, User);
            c.RetrievePassword();
            return c.Password;
        }
        catch (COMException)
        {
            return null; // not paired yet
        }
    }

    public void Set(string token)
    {
        Clear();
        _vault.Add(new PasswordCredential(Resource, User, token));
    }

    public void Clear()
    {
        try
        {
            _vault.Remove(_vault.Retrieve(Resource, User));
        }
        catch (COMException)
        {
            // nothing stored
        }
    }
}
