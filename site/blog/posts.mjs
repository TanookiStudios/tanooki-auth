// The security-tips posts. Each one: plain American English, paraphrased advice only, and every source
// read on `date`. body is trusted HTML written here; links to /guides/ are checked by check-links.mjs.
// Rebuild after editing: node site/blog/build.mjs

const S = {
  cisaMfa: { title: 'More than a Password (CISA)', url: 'https://www.cisa.gov/MFA' },
  ftc2fa: { title: 'Use Two-Factor Authentication To Protect Your Accounts (FTC)', url: 'https://consumer.ftc.gov/articles/use-two-factor-authentication-protect-your-accounts' },
  cisaPeople: { title: 'Individuals and Families (CISA)', url: 'https://www.cisa.gov/audiences/individuals-and-families' },
  cisaPrMfa: { title: 'Implementing Phishing-Resistant MFA, fact sheet (CISA)', url: 'https://www.cisa.gov/sites/default/files/publications/fact-sheet-implementing-phishing-resistant-mfa-508c.pdf' },
  nist63b: { title: 'Digital Identity Guidelines: Authentication, SP 800-63B (NIST)', url: 'https://pages.nist.gov/800-63-4/sp800-63b.html' },
  ftcPhone: { title: 'How To Protect Your Phone From Hackers (FTC)', url: 'https://consumer.ftc.gov/articles/how-protect-your-phone-hackers' },
  appleStolen: { title: 'If your iPhone or iPad was stolen (Apple Support)', url: 'https://support.apple.com/en-us/120837' },
  googleLost: { title: 'Find, secure, or erase a lost Android device (Google Account Help)', url: 'https://support.google.com/accounts/answer/6160500' },
  googleBackup: { title: 'Sign in with backup codes (Google Account Help)', url: 'https://support.google.com/accounts/answer/1187538' },
  githubRecovery: { title: 'Configuring two-factor authentication recovery methods (GitHub Docs)', url: 'https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication-recovery-methods' },
  cisaData: { title: 'How to Protect the Data that is Stored on Your Devices (CISA)', url: 'https://www.cisa.gov/resources-tools/training/how-protect-data-stored-your-devices' },
  googleAuth: { title: 'Get verification codes with Google Authenticator (Google Account Help)', url: 'https://support.google.com/accounts/answer/1066447' },
  msBackup: { title: 'Back up one-time password codes in Microsoft Authenticator (Microsoft Support)', url: 'https://support.microsoft.com/en-us/authenticator/back-up-your-accounts-in-microsoft-authenticator' },
  msRestore: { title: 'Restore one-time password codes in Microsoft Authenticator (Microsoft Support)', url: 'https://support.microsoft.com/en-us/authenticator/restore-account-credentials-from-microsoft-authenticator' },
  ftcPhish: { title: 'How To Recognize and Avoid Phishing Scams (FTC)', url: 'https://consumer.ftc.gov/articles/how-recognize-and-avoid-phishing-scams' },
  cisaPhish: { title: 'Recognize and Report Phishing (CISA)', url: 'https://www.cisa.gov/secure-our-world/recognize-and-report-phishing' },
  fido: { title: 'Passkeys (FIDO Alliance)', url: 'https://fidoalliance.org/passkeys/' },
  googlePasskey: { title: 'Sign in with a passkey instead of a password (Google Account Help)', url: 'https://support.google.com/accounts/answer/13548313' },
  applePasskey: { title: 'About the security of passkeys (Apple Support)', url: 'https://support.apple.com/en-us/102195' },
  ftcSim: { title: 'SIM Swap Scams: How to Protect Yourself (FTC)', url: 'https://consumer.ftc.gov/consumer-alerts/2019/10/sim-swap-scams-how-protect-yourself' },
  ic3Sim: { title: 'Criminals Increasing SIM Swap Schemes to Steal Millions of Dollars from US Public (FBI IC3)', url: 'https://www.ic3.gov/PSA/2022/PSA220208' },
  ftcHacked: { title: 'How To Recover Your Hacked Email or Social Media Account (FTC)', url: 'https://consumer.ftc.gov/articles/how-recover-your-hacked-email-or-social-media-account' },
  cisaTurnOn: { title: 'Turn On MFA (CISA)', url: 'https://www.cisa.gov/secure-our-world/turn-mfa' },
  ftcPassItOn: { title: 'Pass It On (FTC)', url: 'https://consumer.ftc.gov/features/pass-it-on' },
  familyLink: { title: 'Manage your child’s Google Account with Family Link (Google)', url: 'https://support.google.com/families/answer/7103262?hl=en' },
  cisaTravel: { title: 'Holiday Traveling with Personal Internet-Enabled Devices (CISA)', url: 'https://www.cisa.gov/news-events/news/holiday-traveling-personal-internet-enabled-devices' },
  ftcWifi: { title: 'Are Public Wi-Fi Networks Safe? What You Need To Know (FTC)', url: 'https://consumer.ftc.gov/articles/are-public-wi-fi-networks-safe-what-you-need-know' },
};

const a = (s, text) => `<a href="${s.url}">${text}</a>`;

export const posts = [
  {
    slug: 'what-is-two-factor-authentication',
    title: 'What two-factor authentication is, in plain English',
    description: 'Two-factor authentication means a stolen password alone can’t get someone into your account. Here’s how it works and which kind to pick.',
    sources: [S.cisaMfa, S.ftc2fa, S.cisaPeople],
    guides: ['google', 'github'],
    body: `
<p>A password is one thing you know. If someone steals it, they can be you. Two-factor authentication (often shortened to 2FA, and also called multi-factor authentication or MFA) adds a second, different kind of proof before a website lets you in.</p>
<h2>The three kinds of proof</h2>
<p>The U.S. Cybersecurity and Infrastructure Security Agency (CISA) ${a(S.cisaMfa, 'describes three kinds')}: something you know (a password or PIN), something you have (your phone, with an app or a text message on it, or a security key) and something you are (your fingerprint or face). Two-factor means using two of those kinds, not two passwords.</p>
<p>The Federal Trade Commission (FTC) ${a(S.ftc2fa, 'puts it simply')}: with two-factor turned on, a crook who has your password still can’t sign in without the second piece.</p>
<h2>Which second step to choose</h2>
<p>The FTC lists the common options and how they stack up:</p>
<ul>
<li><strong>A code by text message or email.</strong> Much better than nothing.</li>
<li><strong>A code from an authenticator app</strong>, like Tanooki Auth. The FTC calls this safer than text messages, because it doesn’t depend on your phone number.</li>
<li><strong>A security key or passkey.</strong> The strongest option, because it can’t be typed into a fake website.</li>
</ul>
<p>CISA’s advice is that any kind of MFA is better than none. Start with whatever your account offers, and upgrade later.</p>
<h2>Where to turn it on first</h2>
<p>CISA ${a(S.cisaPeople, 'recommends turning it on')} for your email, social media, online shopping and banking accounts. If you only do one today, make it your email, because email is how most other passwords get reset. We explain why in <a href="/blog/protect-your-email-first/">Protect your email first</a>.</p>
<p>Our <a href="/guides/">two-factor guides</a> walk through the exact steps for popular sites, such as <a href="/guides/google/">Google</a> and <a href="/guides/github/">GitHub</a>.</p>
`,
  },
  {
    slug: 'app-codes-vs-text-messages',
    title: 'Authenticator app codes vs text message codes',
    description: 'Text message codes are better than nothing, but authenticator app codes avoid SIM swaps and phone-network attacks. Here’s what the experts say.',
    sources: [S.ftc2fa, S.cisaPrMfa, S.nist63b],
    guides: ['google', 'paypal'],
    body: `
<p>Lots of websites offer to text you a six-digit code when you sign in. Many also let you use an authenticator app instead. Both give you a short code to type in, so what’s the difference?</p>
<h2>Text messages travel through your phone number</h2>
<p>A texted code is only as safe as your phone number. The FTC ${a(S.ftc2fa, 'warns')} that in a SIM swap, a scammer talks your carrier into moving your number to their phone, and then your codes go to them. CISA’s ${a(S.cisaPrMfa, 'fact sheet on phishing-resistant MFA')} goes further: it says text and voice codes are open to phishing, SIM swaps and attacks on the phone network itself, and should only be a last resort.</p>
<p>The National Institute of Standards and Technology (NIST), which writes the federal government’s identity rules, ${a(S.nist63b, 'labels codes sent over the phone network as “restricted”')}: allowed, but with extra conditions, because of these risks.</p>
<h2>App codes never leave your device</h2>
<p>An authenticator app makes the code on your phone or computer from a secret it saved when you scanned the setup QR code. Nothing is sent to you, so there’s nothing to intercept, and a SIM swap doesn’t touch it. It also works with no signal, on a plane or abroad.</p>
<h2>Neither one stops a fake website</h2>
<p>Be honest about the limit: CISA points out that if you type an app code into a convincing fake login page, the scammer can use it too. That’s why passkeys and security keys are rated higher (see <a href="/blog/passkeys-vs-codes/">Passkeys vs codes</a>). Tanooki Auth’s browser extension helps here by filling a code only on the exact website an account belongs to.</p>
<h2>What to do</h2>
<ul>
<li>Where a site offers an authenticator app, switch from text messages to the app.</li>
<li>Once the app works, remove your phone number as a sign-in option if the site lets you, so it can’t be used as a back door.</li>
<li>Save the site’s recovery codes (see <a href="/blog/recovery-codes/">Recovery codes</a>).</li>
</ul>
<p>Our guides show how to switch on sites like <a href="/guides/google/">Google</a> and <a href="/guides/paypal/">PayPal</a>.</p>
`,
  },
  {
    slug: 'lost-your-phone',
    title: 'What to do if you lose your phone',
    description: 'Lost or stolen phone? Lock it, protect your accounts, and get your two-factor codes back. A calm checklist with links to Apple and Google’s own steps.',
    sources: [S.appleStolen, S.googleLost, S.ftcPhone, S.googleBackup],
    guides: ['google'],
    body: `
<p>Losing your phone feels awful, especially when it holds your two-factor codes. Take a breath. Work through this list in order.</p>
<h2>1. Lock it and find it</h2>
<ul>
<li><strong>iPhone:</strong> Apple ${a(S.appleStolen, 'says to')} sign in at iCloud.com/find and turn on Lost Mode. Don’t remove the phone from your account, so Activation Lock keeps it useless to a thief.</li>
<li><strong>Android:</strong> Google ${a(S.googleLost, 'says to')} use google.com/android/find to ring it, lock it and show a message on the screen, or erase it if you need to.</li>
</ul>
<h2>2. Call your carrier</h2>
<p>Ask them to suspend service on the phone, so nobody can receive your texts or calls. Apple also suggests reporting a theft to the police. Google notes your carrier can block the phone by its IMEI number, so it’s worth writing that number down today, while you still have the phone.</p>
<h2>3. Change your most important passwords</h2>
<p>Start with your Apple or Google account and your email, then your bank. Sign out of sessions you don’t recognize.</p>
<h2>4. Get back into accounts that use codes</h2>
<p>This is where preparation pays off:</p>
<ul>
<li>If you saved <strong>recovery codes</strong>, each one gets you in once. Google ${a(S.googleBackup, 'explains how backup codes work')}.</li>
<li>If you have a <strong>backup</strong> of your authenticator, restore it on your new phone. In Tanooki Auth that’s your encrypted backup file and its password, or Premium sync from another device.</li>
<li>If you have neither, you’ll need each website’s account recovery process. It can be slow, on purpose.</li>
</ul>
<h2>Before it happens</h2>
<p>The FTC ${a(S.ftcPhone, 'recommends')} turning on your phone’s find-and-erase feature, using a passcode of at least six digits and backing up regularly. Add two things for your codes: save recovery codes, and keep a backup of your authenticator somewhere other than the phone. See <a href="/blog/backups/">Back up your authenticator</a>.</p>
`,
  },
  {
    slug: 'recovery-codes',
    title: 'Recovery codes: the spare key you’ll be glad you kept',
    description: 'Recovery codes get you back into an account when you lose your two-factor device. What they are, where to keep them, and what not to do.',
    sources: [S.googleBackup, S.githubRecovery],
    guides: ['github', 'google'],
    body: `
<p>When you turn on two-factor login, most websites show you a list of recovery codes (sometimes called backup codes). It’s tempting to click past them. Don’t.</p>
<h2>What they are</h2>
<p>Recovery codes are one-time passwords for emergencies. If you lose your phone or your authenticator, one of these codes gets you in instead. Google ${a(S.googleBackup, 'gives you a set of ten')}, each usable once, and making a new set cancels the old ones. GitHub ${a(S.githubRecovery, 'works the same way')}.</p>
<h2>Where to keep them</h2>
<ul>
<li><strong>Somewhere that isn’t your phone.</strong> The whole point is surviving a lost phone.</li>
<li><strong>Printed and stored safely</strong>, such as with your important papers, or</li>
<li><strong>In a password manager.</strong> GitHub suggests this.</li>
</ul>
<p>Tanooki Auth also has a Recovery codes spot on each account, which is handy as long as your Tanooki backup lives somewhere other than the phone too.</p>
<h2>What not to do</h2>
<ul>
<li>Never share them. Google is clear that it will only ask for one when you’re signing in, never by phone, email or text. Anyone else asking is a scammer.</li>
<li>Don’t keep only a screenshot in your phone’s photo library.</li>
<li>After you use one, cross it off. When you’re running low, make a fresh set.</li>
</ul>
<h2>Set up more than one way in</h2>
<p>GitHub also recommends adding more than one two-factor method, such as an app and a security key, so losing one doesn’t lock you out. That’s good advice everywhere.</p>
<p>Our guides for <a href="/guides/github/">GitHub</a> and <a href="/guides/google/">Google</a> show where to find the codes.</p>
`,
  },
  {
    slug: 'backups',
    title: 'Back up your authenticator before you need to',
    description: 'If your authenticator lives only on one phone, losing that phone locks you out. How to back up your two-factor codes safely.',
    sources: [S.cisaData, S.googleAuth, S.msBackup],
    guides: [],
    body: `
<p>An authenticator app holds the secrets that make your codes. If the only copy is on one phone and that phone is lost, broken or wiped, every account that uses it needs a recovery. A backup turns that disaster into a ten-minute chore.</p>
<h2>What a good backup looks like</h2>
<p>CISA’s ${a(S.cisaData, 'general advice on backups')} applies here: back up often so losing a device doesn’t mean losing data, keep a copy somewhere separate, encrypt your backups, and keep the password somewhere safe.</p>
<p>For an authenticator, that means:</p>
<ul>
<li><strong>Encrypted.</strong> Your backup holds the keys to your accounts. It should be locked with a password only you know.</li>
<li><strong>Somewhere else.</strong> Not just on the same phone. A computer, a USB stick or a cloud drive are all fine for an encrypted file.</li>
<li><strong>Tested.</strong> Restore it once, so you know it works and you remember the password.</li>
</ul>
<h2>How the big apps do it</h2>
<p>Different apps take different approaches. Google Authenticator ${a(S.googleAuth, 'can sync your codes to your Google Account')}. Microsoft Authenticator ${a(S.msBackup, 'backs up to iCloud on iPhone or to a Microsoft account on Android')}, and Microsoft notes it only restores to the same kind of phone. Our <a href="/compare/">comparison pages</a> lay out how each app handles backups, with sources.</p>
<h2>In Tanooki Auth</h2>
<p>Tanooki Auth saves a backup file encrypted with a password you choose. Nobody else has that password, including us, so write it down and keep it safe: if it’s lost, the backup can’t be opened. With Premium you can also sync between your devices, end-to-end encrypted.</p>
<p>Recovery codes are a second safety net. See <a href="/blog/recovery-codes/">Recovery codes</a>.</p>
`,
  },
  {
    slug: 'phishing-fake-login-pages',
    title: 'Phishing and fake login pages: how to spot them',
    description: 'Phishing messages push you to a fake login page that steals your password and code. Warning signs, what to do instead, and where to report it.',
    sources: [S.ftcPhish, S.cisaPhish, S.cisaPrMfa],
    guides: [],
    body: `
<p>Phishing is a message that pretends to be from a company you trust, to get you to hand over a password, a code or money. The most common trick is a link to a fake login page that looks exactly like the real one.</p>
<h2>How a fake login page steals a code</h2>
<p>CISA ${a(S.cisaPrMfa, 'describes the pattern')}: an email sends you to a copy of a real sign-in page. You type your username, your password and the six-digit code from your authenticator. The page passes all three to the attacker, who signs in as you right away. Two-factor codes help a lot, but they can’t tell a real page from a fake one. You have to.</p>
<h2>Warning signs</h2>
<p>The FTC and CISA list the same red flags (${a(S.ftcPhish, 'FTC')}, ${a(S.cisaPhish, 'CISA')}):</p>
<ul>
<li><strong>Urgency.</strong> “Your account will be closed today.” “Unusual sign-in detected.”</li>
<li><strong>A request for personal details, payment information or a code.</strong></li>
<li><strong>Links and sender addresses that are slightly off</strong>, or shortened links that hide where they go.</li>
<li>CISA adds that good spelling and grammar no longer prove a message is real, because scammers use AI tools now.</li>
</ul>
<h2>What to do instead</h2>
<ul>
<li><strong>Don’t use the link or phone number in the message.</strong> Go to the website by typing its address or using your own bookmark, or call a number you already know.</li>
<li><strong>Never read a code to anyone.</strong> No real company calls you to ask for one.</li>
<li><strong>Let your tools check the address.</strong> A password manager won’t fill a password on the wrong site, and Tanooki Auth’s browser extension only fills a code on the exact website that account was saved for. If it won’t fill, stop and look at the address bar.</li>
</ul>
<h2>Report it</h2>
<p>The FTC ${a(S.ftcPhish, 'suggests')} forwarding phishing emails to reportphishing@apwg.org, forwarding scam texts to 7726, and reporting it at ReportFraud.ftc.gov.</p>
<p>For the strongest protection, see <a href="/blog/passkeys-vs-codes/">Passkeys vs codes</a>.</p>
`,
  },
  {
    slug: 'passkeys-vs-codes',
    title: 'Passkeys vs two-factor codes: what’s the difference?',
    description: 'Passkeys can’t be typed into a fake website, which makes them stronger than six-digit codes. When to use each, according to FIDO, Google and Apple.',
    sources: [S.fido, S.googlePasskey, S.applePasskey, S.cisaPrMfa],
    guides: ['google'],
    body: `
<p>More and more sites offer passkeys. You may wonder whether that makes your authenticator app pointless. It doesn’t, but passkeys are worth using where you can.</p>
<h2>What a passkey is</h2>
<p>A passkey lets you sign in with the same face, fingerprint or PIN you use to unlock your phone or computer. The FIDO Alliance, the industry group behind the standard, ${a(S.fido, 'explains')} that there’s nothing to type, so there’s nothing to type into the wrong place.</p>
<p>Apple ${a(S.applePasskey, 'describes why that matters')}: the website only stores a public key, and the private key never leaves your devices. Google ${a(S.googlePasskey, 'adds')} that passkeys can’t be written down, shared or accidentally given away, which makes them much harder to phish.</p>
<h2>Why that beats a code</h2>
<p>A six-digit code is something you can read and type, so a scammer can trick you into typing it into a fake page (see <a href="/blog/phishing-fake-login-pages/">Phishing and fake login pages</a>). A passkey is tied to the real website’s address and simply won’t work on a fake one. That’s why CISA ${a(S.cisaPrMfa, 'ranks')} phishing-resistant methods like passkeys and security keys at the top.</p>
<h2>So why keep an authenticator app?</h2>
<ul>
<li><strong>Not every site offers passkeys yet.</strong> Many still only offer codes.</li>
<li><strong>Some sites ask for a code as a backup</strong> or for certain actions.</li>
<li><strong>Shared or borrowed computers.</strong> Google advises only creating passkeys on devices you personally own and use.</li>
</ul>
<h2>What to do</h2>
<p>Use a passkey where a site offers one, starting with your email and your Apple or Google account. Keep an authenticator app for everything else, and keep recovery codes for both. Our <a href="/guides/google/">Google guide</a> covers turning on two-step verification, and Google’s help page above covers passkeys.</p>
`,
  },
  {
    slug: 'sim-swapping',
    title: 'SIM swapping: how scammers steal your phone number',
    description: 'In a SIM swap, a scammer moves your phone number to their phone and gets your text message codes. How it works and how to protect yourself.',
    sources: [S.ftcSim, S.ic3Sim],
    guides: ['paypal', 'binance', 'kraken'],
    body: `
<p>Your phone number feels like it belongs to you. To your carrier, it’s an account that can be moved to a new SIM card, and a scammer can sometimes talk them into doing exactly that.</p>
<h2>How a SIM swap works</h2>
<p>The FTC ${a(S.ftcSim, 'explains it')}: a scammer contacts your carrier pretending to be you, says your phone was lost, and asks to move your number to a SIM card they control. Once it moves, your calls and texts, including your sign-in codes, go to them. Your own phone suddenly loses service.</p>
<h2>It’s a real and growing problem</h2>
<p>The FBI’s Internet Crime Complaint Center ${a(S.ic3Sim, 'reported in 2022')} that it received 320 SIM swapping complaints from January 2018 to December 2020, with adjusted losses of about $12 million, and 1,611 complaints in 2021 alone, with adjusted losses of more than $68 million.</p>
<h2>How to protect yourself</h2>
<ul>
<li><strong>Move off text message codes.</strong> The FTC and FBI both recommend an authenticator app or a security key instead. A SIM swap can’t touch codes made on your device. See <a href="/blog/app-codes-vs-text-messages/">App codes vs text messages</a>.</li>
<li><strong>Add a PIN or passcode to your carrier account.</strong> The FTC suggests this.</li>
<li><strong>Share less online.</strong> The FBI advises not posting your phone number, address or details about money or cryptocurrency you own.</li>
<li><strong>Never give your carrier PIN to someone who calls you.</strong> Hang up and call your carrier’s real number.</li>
<li><strong>Notice a sudden loss of service.</strong> If your phone shows “No service” for no reason, call your carrier from another phone right away.</li>
</ul>
<p>Money and crypto accounts are favorite targets. Our guides show how to switch them to an authenticator app, for example <a href="/guides/paypal/">PayPal</a>.</p>
`,
  },
  {
    slug: 'moving-to-a-new-phone',
    title: 'Moving to a new phone without losing your codes',
    description: 'Getting a new phone? Move your two-factor codes over first and keep the old phone until every account works. A step-by-step plan.',
    sources: [S.googleAuth, S.msRestore],
    guides: [],
    body: `
<p>New phone day is exciting. The one way to ruin it is wiping the old phone before your codes have moved. Here’s the safe order.</p>
<h2>1. Don’t wipe or trade in the old phone yet</h2>
<p>Keep it working until you’ve confirmed every account on the new one. Microsoft ${a(S.msRestore, 'gives the same advice')}: some accounts have to be signed into again on the new phone, so hold on to the old one until that’s done.</p>
<h2>2. Move your codes</h2>
<p>How depends on your app:</p>
<ul>
<li><strong>Tanooki Auth:</strong> make a fresh encrypted backup on the old device and open it on the new one, or turn on Premium sync. You can also show an account as a QR code and scan it on the new phone.</li>
<li><strong>Google Authenticator:</strong> Google ${a(S.googleAuth, 'explains')} that synced codes appear when you sign in on the new phone; otherwise, use Transfer accounts to show QR codes and scan them.</li>
<li><strong>Microsoft Authenticator:</strong> Microsoft ${a(S.msRestore, 'notes')} you can only restore to the same kind of phone, iPhone to iPhone or Android to Android.</li>
</ul>
<p>Switching apps at the same time? Tanooki Auth can bring accounts over from Google Authenticator, Aegis and 2FAS. Our <a href="/compare/">comparison pages</a> explain how for each app.</p>
<h2>3. Test every account</h2>
<p>Open each account in the new app and check that its code works: sign in to the site, or compare the code with the old phone (they should match). Pay extra attention to your email, bank and Apple or Google account.</p>
<h2>4. Update the phone number if it changed</h2>
<p>If your number is new, update it on sites that use it for recovery.</p>
<h2>5. Then wipe the old phone</h2>
<p>Only after everything works. Keep your recovery codes handy for the first week, just in case. See <a href="/blog/recovery-codes/">Recovery codes</a>.</p>
`,
  },
  {
    slug: 'protect-your-email-first',
    title: 'Protect your email first',
    description: 'Whoever controls your email can reset most of your other passwords. Why your email account deserves your strongest protection, and how.',
    sources: [S.ftcHacked, S.cisaTurnOn, S.cisaPeople],
    guides: ['google', 'yahoo', 'proton'],
    body: `
<p>If you only have time to secure one account today, make it your email. Here’s why.</p>
<h2>Email is the master key</h2>
<p>Almost every website has a “Forgot password?” link, and almost every one sends the reset to your email. The FTC ${a(S.ftcHacked, 'warns')} that a hacker who controls your email can reset the passwords on your other accounts and lock you out of them. CISA’s ${a(S.cisaTurnOn, 'Turn On MFA page')} tells the story of a scammer who took over one email account and used it to get into the bank and shopping accounts linked to it.</p>
<h2>Lock it down</h2>
<ul>
<li><strong>Use a strong password you don’t use anywhere else.</strong> A password manager makes this easy.</li>
<li><strong>Turn on two-factor authentication</strong>, ideally a passkey or an authenticator app rather than text messages. Our guides cover <a href="/guides/google/">Gmail (Google)</a>, <a href="/guides/yahoo/">Yahoo</a> and <a href="/guides/proton/">Proton</a>.</li>
<li><strong>Check your recovery email and phone number.</strong> Make sure they’re yours and current.</li>
<li><strong>Save your recovery codes</strong> somewhere off your phone.</li>
<li><strong>Review signed-in devices</strong> and sign out of any you don’t recognize.</li>
</ul>
<h2>Signs your email was hacked</h2>
<p>The FTC lists the warning signs: you can’t log in, you get a notice about a password change or a sign-in from a device you don’t know, or friends get messages from you that you didn’t send. After a hack, also check your settings for <strong>forwarding rules</strong>, which can quietly send copies of your mail to someone else.</p>
<p>If it happens, the FTC ${a(S.ftcHacked, 'recommends')} changing the password, signing out of all devices, turning on two-factor, checking the recovery details, deleting forwarding rules you didn’t set up, and warning your contacts.</p>
<p>Then do the same for your other important accounts. CISA ${a(S.cisaPeople, 'suggests')} social media, shopping and banking next.</p>
`,
  },
  {
    slug: 'family-accounts',
    title: 'Helping your family stay safe online',
    description: 'Practical ways to help parents, kids and other family members with two-factor login and scams, without taking over their accounts.',
    sources: [S.ftcPassItOn, S.familyLink, S.cisaMfa],
    guides: [],
    body: `
<p>Most families have one person everyone calls when something on the computer goes wrong. If that’s you, a little setup now saves a lot of panic later.</p>
<h2>Talk about scams, kindly</h2>
<p>The FTC’s ${a(S.ftcPassItOn, 'Pass It On')} campaign is built for exactly this: short, friendly material about common scams, like fake tech support and impersonation, to share with people you care about. The message that matters most: <strong>no real company will ever call or text asking for a code or password.</strong> If someone does, hang up and call the company back on a number you already know.</p>
<h2>Turn on two-factor together</h2>
<p>Sit down with them and turn on two-factor for their email first, then their bank. CISA ${a(S.cisaMfa, 'notes')} that any MFA is far better than none, so pick the option they’ll actually use. An authenticator app is a good fit for most people. Our <a href="/guides/">guides</a> make it step by step.</p>
<h2>Plan for the lost phone</h2>
<ul>
<li>Help them save recovery codes and put a printed copy with their important papers.</li>
<li>Set up an encrypted backup of their authenticator, and make sure they know where the password is.</li>
<li>Write down who to call and what to do if their phone is lost. Our <a href="/blog/lost-your-phone/">lost phone checklist</a> is a good start.</li>
</ul>
<h2>Kids’ accounts</h2>
<p>If you manage a child’s Google Account with Family Link, Google ${a(S.familyLink, 'notes')} that resetting their password turns off their 2-Step Verification. You both get an email, and they can turn it back on. Remember to do that.</p>
<h2>Sharing an account</h2>
<p>Some accounts really are shared, like a streaming service or a utility. Don’t share your whole authenticator to cover it. Tanooki Auth Premium can share one account with someone you trust, and the Family plan covers up to five people. Whatever you use, share just the account, not everything.</p>
`,
  },
  {
    slug: 'travel-tips',
    title: 'Security tips for travel',
    description: 'Traveling with your phone and laptop? Keep your two-factor codes working abroad and your accounts safe on public Wi-Fi and charging stations.',
    sources: [S.cisaTravel, S.ftcWifi, S.ftc2fa],
    guides: [],
    body: `
<p>Travel is when your usual safety nets are furthest away: a different phone plan, unfamiliar Wi-Fi, and a higher chance of losing a device. A few minutes of prep before you leave makes a big difference.</p>
<h2>Before you go</h2>
<ul>
<li><strong>Make sure your codes work without a phone signal.</strong> Text message codes may not arrive abroad or on a local SIM. Authenticator app codes are made on your device and work offline, which the FTC ${a(S.ftc2fa, 'notes')} is also safer. See <a href="/blog/app-codes-vs-text-messages/">App codes vs text messages</a>.</li>
<li><strong>Back up your authenticator</strong> and leave a copy at home or in encrypted cloud storage. See <a href="/blog/backups/">Back up your authenticator</a>.</li>
<li><strong>Pack your recovery codes</strong> separately from your phone, for example printed in your carry-on or saved in a password manager.</li>
<li><strong>Update your devices</strong> and turn on find-and-erase, so a lost phone can be locked from anywhere.</li>
</ul>
<h2>On the road</h2>
<ul>
<li><strong>Be careful on public Wi-Fi.</strong> The FTC ${a(S.ftcWifi, 'says')} most public Wi-Fi is usually safe now because most sites encrypt traffic, but a fake website can be encrypted too. Check the address before you sign in. CISA ${a(S.cisaTravel, 'suggests')} switching to mobile data for banking and shopping.</li>
<li><strong>Skip public USB charging stations.</strong> CISA advises against charging from public USB ports or shared computers. Bring your own charger and plug it into a wall outlet.</li>
<li><strong>Turn off Bluetooth when you’re not using it</strong>, as CISA also suggests.</li>
<li><strong>Don’t sign in on hotel or shared computers.</strong> You can’t know what’s running on them.</li>
</ul>
<h2>If your phone goes missing abroad</h2>
<p>Follow our <a href="/blog/lost-your-phone/">lost phone checklist</a>. Your recovery codes and backup are what get you back in from a borrowed device or a new phone.</p>
`,
  },
];
