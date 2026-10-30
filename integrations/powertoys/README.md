# Tanooki Auth for PowerToys

Search your Tanooki Auth accounts from PowerToys on Windows and press Enter to copy the current code.

It works with **Command Palette**, the launcher PowerToys ships now (Windows key + Alt + Space).
Microsoft calls it the next version of PowerToys Run, and new extensions are built for it, so this
isn't a PowerToys Run plugin.

It talks only to the Tanooki Auth app on the same PC, the same way the browser extension and Raycast do.
It never sees your secret keys, only one code at a time, and copied codes are kept out of Windows
clipboard history.

## Before you start

- Windows 10 or 11, with [PowerToys](https://aka.ms/installpowertoys) installed and Command Palette
  turned on (it's on by default in new PowerToys versions).
- The Tanooki Auth app installed on the same PC. It needs a version that accepts PowerToys. If yours
  is older, the extension tells you "Tanooki Auth is running but doesn't accept PowerToys yet".

## Install it

You do this part yourself because it changes a Windows setting, and only you can do that on your PC.

1. **Download it.** On GitHub, open the repository, click **Actions** at the top, click **PowerToys** on
   the left, then click the newest run with a green tick. Scroll down to **Artifacts** and click
   **tanooki-auth-powertoys**. A zip file downloads.
2. **Unzip it somewhere it can stay.** In File Explorer, open your Downloads folder, right-click the zip,
   choose **Extract All…**, and change the folder to `Documents\Tanooki Auth for PowerToys`. Click
   **Extract**. Leave this folder there afterwards: Windows runs the extension from it.
3. **Turn on Developer Mode.** Click Start, then **Settings**, then **System**, then **Advanced**
   (called **For developers** on some versions; on Windows 10 it's **Update & Security**, then
   **For developers**). Switch **Developer Mode** on and click **Yes**. Windows needs this to install apps that don't come from the Microsoft Store.
4. **Run the installer.** In the folder from step 2, double-click **install.cmd**. If a blue box says
   "Windows protected your PC", click **More info**, then **Run anyway**. A black window opens and ends
   with "Installed." Press any key to close it.
   - If it says "Developer Mode is off", go back to step 3.
   - If it shows red text, copy the text and send it to me.
5. **Reload Command Palette.** Press Windows key + Alt + Space, type `Reload`, and pick
   **Reload Command Palette extensions**.

## Pair it (once)

1. Open the Tanooki Auth app on your PC and unlock it.
2. Press Windows key + Alt + Space, type `Tanooki`, and press Enter on **Tanooki Auth**.
3. You'll see **Pair with Tanooki Auth**. Press Enter.
4. The Tanooki Auth app shows a 6-digit code. Type it into Command Palette's search box. When the line
   says **Pair using code 123 456**, press Enter.
5. It says "PowerToys is paired with Tanooki Auth", and your accounts appear.

If you type the code wrong three times, or close the code in the app, press Enter on
**Pair with Tanooki Auth** again for a new code.

## Use it

Press Windows key + Alt + Space, type `Tanooki`, press Enter, then start typing an account's name or
website. Press Enter on the account and the code is copied. Paste it wherever it's asked for.

What the messages mean:

| You see | What to do |
|---|---|
| Open Tanooki Auth | The app isn't running. Open it, then press Enter to try again. |
| Unlock Tanooki Auth | The app is locked. Unlock it, then press Enter. |
| Update Tanooki Auth | The app is too old to talk to PowerToys. Update it. |
| Pair with Tanooki Auth | Not paired, or you removed the pairing in the app's Settings. Pair again. |

## Remove it

Double-click **uninstall.cmd** in the same folder, then delete the folder. You can turn Developer Mode
back off afterwards.

## For developers

- `TanookiBridge/` is the bridge client and search (plain .NET, no Windows-only parts).
  `TanookiBridge.Tests/` runs it against the shared fake app in `integrations/test/fake-bridge.mjs`
  (needs Node): `dotnet test TanookiBridge.Tests`.
- `TanookiAuthCommandPalette/` is the Command Palette extension, from Microsoft's template. Build with
  `dotnet build TanookiAuthCommandPalette -c Release -p:Platform=x64 -r win-x64 --self-contained -p:GenerateAppxPackageOnBuild=true -p:AppxPackageSigningEnabled=false`,
  then `./make-folder.ps1 -Out <folder>` makes the folder described above.
- It connects with the Origin `tanooki-integration://powertoys` and keeps its pairing token in Windows
  Credential Manager under "Tanooki Auth bridge" / "powertoys". The app has to accept that Origin; see
  `integrations/BRIDGE-CHANGES.md`.
- CI: `.github/workflows/powertoys.yml` runs the tests, builds it, installs it, and starts it through COM
  the way Command Palette does.
