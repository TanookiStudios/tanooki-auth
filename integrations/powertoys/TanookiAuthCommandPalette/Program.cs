// Entry point from Microsoft's Command Palette extension template: PowerToys starts this as a COM server.
using System;
using System.Threading;
using Microsoft.CommandPalette.Extensions;
using Shmuelie.WinRTServer.CsWinRT;

namespace TanookiAuthCommandPalette;

public static class Program
{
    [MTAThread]
    public static void Main(string[] args)
    {
        if (args.Length > 0 && args[0] == "-RegisterProcessAsComServer")
        {
            global::Shmuelie.WinRTServer.ComServer server = new();
            ManualResetEvent disposed = new(false);
            TanookiAuthExtension extension = new(disposed);
            server.RegisterClass<TanookiAuthExtension, IExtension>(() => extension);
            server.Start();
            disposed.WaitOne(); // until Command Palette lets go of the extension
            server.Stop();
            server.UnsafeDispose();
        }
        else
        {
            Console.WriteLine("This is a PowerToys Command Palette extension. Open Command Palette and type Tanooki.");
        }
    }
}
