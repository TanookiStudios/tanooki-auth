// Builds assets/brand_icons/icons.json from Simple Icons (CC0). Run once when the list changes:
//   mkdir /tmp/si && cd /tmp/si && npm i simple-icons svgpath
//   node <repo>/app/tool/make_brand_icons.mjs /tmp/si/node_modules <repo>/app/assets/brand_icons
// Paths are normalized to absolute M/L/H/V/C/Q/Z so the app's tiny parser can draw them.
import { readFileSync, writeFileSync, copyFileSync } from 'node:fs';
import { createRequire } from 'node:module';

const [mods, out] = process.argv.slice(2);
const require = createRequire(`${mods}/`);
const svgpath = require('svgpath');
const si = require('simple-icons');
const data = JSON.parse(readFileSync(`${mods}/simple-icons/data/simple-icons.json`, 'utf8'));
const meta = Object.fromEntries(data.map((d) => [d.slug, d]));
const okLicense = new Set(['CC0-1.0', 'MIT', 'Apache-2.0', 'BSD-2-Clause', 'BSD-3-Clause', 'ISC']);

// domain -> Simple Icons slug. Popular sites that offer authenticator-app 2FA.
const sites = {
  'github.com': 'github', 'gitlab.com': 'gitlab', 'bitbucket.org': 'bitbucket', 'google.com': 'google',
  'gmail.com': 'gmail', 'youtube.com': 'youtube', 'apple.com': 'apple', 'icloud.com': 'icloud',
  'facebook.com': 'facebook', 'instagram.com': 'instagram', 'threads.net': 'threads', 'whatsapp.com': 'whatsapp',
  'meta.com': 'meta', 'x.com': 'x', 'twitter.com': 'x', 'discord.com': 'discord', 'reddit.com': 'reddit',
  'twitch.tv': 'twitch', 'tiktok.com': 'tiktok', 'snapchat.com': 'snapchat', 'pinterest.com': 'pinterest',
  'tumblr.com': 'tumblr', 'mastodon.social': 'mastodon', 'bsky.app': 'bluesky', 'telegram.org': 'telegram',
  'signal.org': 'signal', 'slack.com': 'slack', 'zoom.us': 'zoom', 'dropbox.com': 'dropbox', 'box.com': 'box',
  'proton.me': 'proton', 'protonmail.com': 'protonmail', 'tutanota.com': 'tutanota', 'fastmail.com': 'fastmail',
  'zoho.com': 'zoho', 'yahoo.com': 'yahoo', 'mozilla.org': 'mozilla', 'firefox.com': 'firefox',
  'npmjs.com': 'npm', 'pypi.org': 'pypi', 'docker.com': 'docker', 'hub.docker.com': 'docker',
  'cloudflare.com': 'cloudflare', 'digitalocean.com': 'digitalocean', 'heroku.com': 'heroku',
  'vercel.com': 'vercel', 'netlify.com': 'netlify', 'linode.com': 'linode', 'vultr.com': 'vultr',
  'hetzner.com': 'hetzner', 'ovhcloud.com': 'ovh', 'fly.io': 'flydotio', 'render.com': 'render',
  'supabase.com': 'supabase', 'firebase.google.com': 'firebase', 'mongodb.com': 'mongodb',
  'atlassian.com': 'atlassian', 'jira.com': 'jira', 'trello.com': 'trello', 'notion.so': 'notion',
  'figma.com': 'figma', 'canva.com': 'canva', 'adobe.com': 'adobe', 'asana.com': 'asana',
  'linear.app': 'linear', 'airtable.com': 'airtable', 'evernote.com': 'evernote', 'todoist.com': 'todoist',
  'miro.com': 'miro', 'clickup.com': 'clickup', 'monday.com': 'mondaydotcom', 'hubspot.com': 'hubspot',
  'mailchimp.com': 'mailchimp', 'shopify.com': 'shopify', 'wordpress.com': 'wordpress', 'wix.com': 'wix',
  'squarespace.com': 'squarespace', 'godaddy.com': 'godaddy', 'namecheap.com': 'namecheap',
  'porkbun.com': 'porkbun', 'stripe.com': 'stripe', 'paypal.com': 'paypal', 'venmo.com': 'venmo',
  'cash.app': 'cashapp', 'wise.com': 'wise', 'revolut.com': 'revolut', 'coinbase.com': 'coinbase',
  'kraken.com': 'kraken', 'binance.com': 'binance', 'gemini.com': 'gemini', 'robinhood.com': 'robinhood',
  'patreon.com': 'patreon', 'kofi.com': 'kofi', 'ko-fi.com': 'kofi', 'buymeacoffee.com': 'buymeacoffee',
  'gumroad.com': 'gumroad', 'etsy.com': 'etsy', 'ebay.com': 'ebay', 'steampowered.com': 'steam',
  'store.steampowered.com': 'steam', 'epicgames.com': 'epicgames', 'ea.com': 'ea', 'ubisoft.com': 'ubisoft',
  'battle.net': 'battledotnet', 'blizzard.com': 'blizzard', 'playstation.com': 'playstation',
  'nintendo.com': 'nintendo', 'gog.com': 'gogdotcom', 'roblox.com': 'roblox', 'itch.io': 'itchdotio',
  'humblebundle.com': 'humblebundle', 'riotgames.com': 'riotgames', 'spotify.com': 'spotify',
  'soundcloud.com': 'soundcloud', 'bandcamp.com': 'bandcamp', 'tidal.com': 'tidal', 'deezer.com': 'deezer',
  'netflix.com': 'netflix', 'hulu.com': 'hulu', 'plex.tv': 'plex', 'crunchyroll.com': 'crunchyroll',
  'vimeo.com': 'vimeo', 'bitwarden.com': 'bitwarden', '1password.com': '1password', 'lastpass.com': 'lastpass',
  'dashlane.com': 'dashlane', 'keepassxc.org': 'keepassxc', 'nordvpn.com': 'nordvpn', 'expressvpn.com': 'expressvpn',
  'mullvad.net': 'mullvad', 'protonvpn.com': 'protonvpn', 'tailscale.com': 'tailscale', 'synology.com': 'synology',
  'ubiquiti.com': 'ubiquiti', 'ui.com': 'ubiquiti', 'okta.com': 'okta', 'auth0.com': 'auth0', 'twilio.com': 'twilio',
  'sentry.io': 'sentry', 'datadoghq.com': 'datadog', 'grafana.com': 'grafana', 'newrelic.com': 'newrelic',
  'pagerduty.com': 'pagerduty', 'circleci.com': 'circleci', 'travis-ci.com': 'travisci', 'jetbrains.com': 'jetbrains',
  'expo.dev': 'expo', 'unity.com': 'unity', 'unrealengine.com': 'unrealengine', 'hackerone.com': 'hackerone',
  'kaggle.com': 'kaggle', 'huggingface.co': 'huggingface', 'openai.com': 'openai', 'anthropic.com': 'anthropic',
  'claude.ai': 'claude', 'duolingo.com': 'duolingo', 'udemy.com': 'udemy', 'coursera.org': 'coursera',
  'medium.com': 'medium', 'substack.com': 'substack', 'quora.com': 'quora', 'stackoverflow.com': 'stackoverflow',
  'airbnb.com': 'airbnb', 'uber.com': 'uber', 'lyft.com': 'lyft', 'doordash.com': 'doordash', 'instacart.com': 'instacart',
  'booking.com': 'bookingdotcom', 'tripadvisor.com': 'tripadvisor', 'nextdns.io': 'nextdns', 'namesilo.com': 'namesilo',
  'gandi.net': 'gandi', 'backblaze.com': 'backblaze', 'mega.nz': 'mega', 'pcloud.com': 'pcloud', 'nextcloud.com': 'nextcloud',
  'wikipedia.org': 'wikipedia', 'archive.org': 'internetarchive', 'kickstarter.com': 'kickstarter', 'indeed.com': 'indeed',
  'glassdoor.com': 'glassdoor', 'fiverr.com': 'fiverr', 'upwork.com': 'upwork', 'tesla.com': 'tesla', 'ring.com': 'ring',
};

const icons = {};
const skipped = [];
for (const [domain, slug] of Object.entries(sites)) {
  const key = `si${slug[0].toUpperCase()}${slug.slice(1)}`;
  const icon = si[key];
  const lic = meta[slug]?.license?.type;
  if (!icon || (lic && !okLicense.has(lic))) {
    skipped.push(`${domain} (${icon ? `license ${lic}` : 'not in Simple Icons'})`);
    continue;
  }
  const d = svgpath(icon.path).abs().unarc().unshort().round(2).toString();
  icons[domain] = { t: icon.title, c: icon.hex, p: d };
}
writeFileSync(`${out}/icons.json`, JSON.stringify(icons));
copyFileSync(`${mods}/simple-icons/LICENSE.md`, `${out}/LICENSE.md`);
copyFileSync(`${mods}/simple-icons/DISCLAIMER.md`, `${out}/DISCLAIMER.md`);
console.log(`wrote ${Object.keys(icons).length} icons; skipped ${skipped.length}:\n  ${skipped.join('\n  ')}`);
