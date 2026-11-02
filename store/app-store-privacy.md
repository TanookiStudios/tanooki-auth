# App Store "App Privacy" answers for Tanooki Auth

Apple doesn't let these be filled in through its API, so this one has to be clicked by hand in
App Store Connect by someone signed in to the account. The rest of the listing (text, screenshots,
categories, age rating, build) is already filled in.

The answers are the same for iPhone/iPad and Mac (it's one app record).

## What actually leaves the device (so the answers make sense)

| Thing | What's sent | Kept? |
| --- | --- | --- |
| Your accounts and codes | Nothing, ever. | — |
| Clock check (automatic, at most once an hour) | A plain request to the relay's `/health` for the current time. No data about you. | Not stored. |
| Feedback form (Settings > Help, only if you send it) | Your message, platform, app version, and an email only if you type one. | Yes, stored so Maddie can read it. |
| Buying Premium in the App Store app | Apple's signed receipt, checked by our server. | Not stored. |
| Sync, phone approval, emergency access (off unless turned on) | End-to-end encrypted data the server can't read. Phone approval also keeps the phone's notification address (from Apple or Google) until you unlink it. | Encrypted data, yes, but unreadable to us. |
| Breach alerts (off unless turned on) | Downloads the public breach list. Nothing about you is sent. | — |

## Exactly what to click

1. Go to **appstoreconnect.apple.com**, sign in, click **Apps**, then **Tanooki Auth**.
2. In the left sidebar, under **General**, click **App Privacy**.
3. Next to **Privacy Policy**, check it shows
   `https://tanooki-auth-premium.kirbymail.workers.dev/privacy` (already set).
4. Under **Data Types**, click **Get Started** (or **Edit** if you've been here before).
5. Question: **"Do you or your third-party partners collect data from this app?"**
   Pick **Yes, we collect data from this app.** (The feedback form is the reason. See the note at the
   bottom if you'd rather pick No.)
6. On the list of data types, tick only these two, then click **Save**:
   - **Contact Info > Email Address**
   - **User Content > Customer Support**
   Leave every other box empty (no Location, no Identifiers, no Usage Data, no Diagnostics,
   no Purchases, no Health, no Financial Info, no Browsing History, no Contacts, no Sensitive Info).
7. The page now lists those two with **Set Up** buttons. For **each** of them, click **Set Up** and answer:
   - "How is this data used?": tick **App Functionality** only. Click **Next**.
   - "Is this data linked to the user's identity?": **Yes**. Click **Next**.
     (An email you type in identifies you, so Yes is the honest answer.)
   - "Do you or your third-party partners use this data for tracking purposes?": **No**. Click **Save**.
8. At the top right of the App Privacy page, click **Publish**. You'll see the label preview change to
   "Data Linked to You: Contact Info, User Content". If **Publish** is grayed out, one of the two
   data types still says **Set Up**; finish it.

What the App Store page will then show: **Data Linked to You: Contact Info, User Content**, and
nothing under "Data Used to Track You".

## Why not "Data Not Collected"?

Apple allows leaving out data from optional feedback forms if it's sent rarely, only when the person
chooses to, and they can see what they're sending. The feedback form arguably fits that, and picking
**No, we do not collect data from this app** in step 5 would give the big "Data Not Collected" label.
It's a judgment call. The answers above are the safe, can't-be-wrong version; choosing No is defensible
but if App Review disagrees they'll ask you to change it.

Things deliberately **not** declared, and why:
- Purchases: Apple handles the payment; our server checks the receipt and throws it away.
- Sync / phone approval / emergency access data: end-to-end encrypted on your devices; we can't read it.
- The phone's notification address for phone approval: an app-level push address, not a device ID or
  anything that identifies the person, used only to deliver the approval request.
- The clock check: no data about the person is in it, and nothing is kept.

## Heads-up: the privacy policy page is missing one thing

The page at `/privacy` says the app makes no internet connections unless you turn features on. That's
no longer quite true: the automatic clock check (README, `app/lib/core/clock_check.dart`) asks the relay
for the time. It sends nothing about you, but the policy should mention it, so the page and the app
agree. That page is served by `worker/`, not the site; it hasn't been changed.
