# Microsoft Store — Tanooki Auth

The Store package (an `.msix` file) is built by the Windows workflow on GitHub on every push.
Putting it in the Store needs a Microsoft Partner Center account, and only you can sign up
and pay for that (it asks for your name, payment card and identity), so these steps are yours.

## 1. Make a Partner Center account (one time)

1. Go to https://storedeveloper.microsoft.com and click **Get started**.
2. Sign in with your Microsoft account (the one you use for Outlook or Xbox is fine).
3. Pick **Individual** unless Tanooki Studios is a registered company with paperwork.
4. Fill in your name, address and contact email, and pay the one-time fee if it asks.
5. When it's done you land on the Partner Center home page with a tile called **Apps and games**.

## 2. Reserve the name

1. In Partner Center click **Apps and games**, then **New product**, then **MSIX or PWA app**.
2. Type `Tanooki Auth` and click **Check availability**, then **Reserve product name**.
3. You now see the app's overview page.

## 3. Copy the three identity values into GitHub

1. On the app's page, in the left menu, open **Product management** > **Product identity**.
2. You'll see three lines. Keep this page open:
   - **Package/Identity/Name** (looks like `12345TanookiStudios.TanookiAuth`)
   - **Package/Identity/Publisher** (starts with `CN=` followed by letters and numbers)
   - **Package/Properties/PublisherDisplayName** (probably `Tanooki Studios`)
3. In another tab open https://github.com/TanookiStudios/tanooki-auth/settings/variables/actions
4. Click **New repository variable** three times, once for each:

   | Name                          | Value (copy from Partner Center)          |
   |-------------------------------|-------------------------------------------|
   | `MSIX_IDENTITY_NAME`          | Package/Identity/Name                     |
   | `MSIX_PUBLISHER`              | Package/Identity/Publisher (the whole `CN=...`) |
   | `MSIX_PUBLISHER_DISPLAY_NAME` | Package/Properties/PublisherDisplayName   |

   These aren't secrets, which is why they go under **Variables**, not **Secrets**.
5. Tell Claude they're in. Claude re-runs the Windows workflow so the package carries your real identity.
   If the values are wrong, Partner Center rejects the upload in step 5 with a message about
   the "package identity" not matching. That's the sign to re-check the three variables.

## 4. Download the package

1. Open https://github.com/TanookiStudios/tanooki-auth/actions/workflows/windows.yml
2. Click the newest run with a green tick.
3. Scroll to the bottom, to **Artifacts**, and click **tanooki-auth-windows-msix**. A zip downloads.
4. Unzip it. Inside is `TanookiAuth.msix`. That's the file you upload.

## 5. Make the submission

1. Back in Partner Center, on the app's page, click **Start submission**.
2. **Pricing and availability**: Free, all markets.
3. **Properties**: Category **Utilities + tools**, subcategory none. Privacy policy URL:
   https://tanooki-auth-premium.kirbymail.workers.dev/privacy
4. **Age ratings**: answer the questionnaire (no violence, no user chat, no purchases of
   physical goods). It ends with a rating like "3+".
5. **Packages**: drag `TanookiAuth.msix` onto the box. After a minute it shows a green
   "Validated" line. A red message means the identity values in step 3 don't match.
6. **Store listings** > **English (United States)**: paste the description from
   `store/chrome-web-store.md` (change "the extension" wording to the app), and add at least
   one screenshot of the Windows app (1366x768 or bigger).
7. **Submission options**: leave as is. Under "restricted capabilities", the package asks for
   `runFullTrust` (every normal desktop app does). Write: "Desktop app built with Flutter;
   needs full trust to run as a regular Windows program and show a tray icon."
8. Click **Submit to the Store**. Certification usually takes 1 to 3 days. You get an email either way.
