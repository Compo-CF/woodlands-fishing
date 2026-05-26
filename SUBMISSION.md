# Submission Day — End-to-End Guide

Everything you need to take the app from "compiles in CI" to "in TestFlight" to "live on the App Store." Pull this doc up on your second screen when you're ready to submit.

## Prerequisites checklist

Before booting up a Mac, confirm:

- [ ] **Apple Developer Program** active — check [developer.apple.com/account](https://developer.apple.com/account) shows "Membership" with an expiration date. Signup activation takes 24-48 hours.
- [ ] **Two-factor auth** on your Apple ID
- [ ] **App icon** — 1024×1024 PNG, no transparency, no rounded corners (Apple rounds them at render time)
- [ ] **Screenshots** — 6.7" iPhone (1290×2796 PNG), 3-10 of them. Easiest: take them from the Xcode simulator running your app.
- [ ] **App metadata drafted** — name, subtitle, description, keywords, support URL, privacy policy URL
- [ ] **Latest code pushed** and CI build is green
- [ ] **Your Apple Developer Team ID** — 10-character string at [developer.apple.com/account/membership](https://developer.apple.com/account/membership)

## Step 1 — Sign up for MacInCloud (~5 min, ~$5)

1. Go to [macincloud.com](https://www.macincloud.com/)
2. Pick a plan:
   - **Pay-As-You-Go ($1/hr)** — best for first-time setup. Buy a 5-hour block.
   - **Managed Server (~$30/mo)** — if you'll submit monthly updates.
3. After purchase you'll get email with hostname, username, password, and port.
4. **Verify Xcode is pre-installed** on your plan. Most "Developer" plans include it. If not, install from the Mac App Store on first login (free, but ~30 min download).

## Step 2 — Connect from Windows (~2 min)

Use **Remote Desktop Connection**, already built into Windows 11:

1. Start menu → "Remote Desktop Connection"
2. Computer: `<hostname>:<port>` from your MacInCloud email
3. Username/password from email
4. Maximize the RDP window *before* connecting for a full-screen Mac

If RDP is sluggish, lower the display quality in the Experience tab.

## Step 3 — First-time Mac setup (~15 min)

Open Terminal on the Mac (Spotlight → "Terminal"):

```bash
# 1. Homebrew (if not pre-installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. XcodeGen
brew install xcodegen

# 3. Clone your repo
cd ~/Documents
git clone https://github.com/Compo-CF/woodlands-fishing.git
cd woodlands-fishing
```

Then open Xcode → Settings → Accounts → **+** → Apple ID → sign in. Your Apple Developer team should appear once auth completes.

## Step 4 — Wire the project to your team

Edit `project.yml` and replace the empty `DEVELOPMENT_TEAM` value with your 10-character Team ID:

```yaml
DEVELOPMENT_TEAM: ABC1234XYZ
```

Then generate and open the project:

```bash
xcodegen generate
open WoodlandsFishing.xcodeproj
```

In Xcode, click the project in the left sidebar → **Signing & Capabilities** tab → ensure:
- ✅ Automatically manage signing
- Team: (your name)
- Bundle Identifier: `com.compofelice.WoodlandsFishing`

Xcode should generate a provisioning profile automatically. If it errors with "no team", revisit Step 3 to verify the Apple ID was added.

## Step 5 — Create the app in App Store Connect (~20 min)

In a browser (Mac or Windows, either works):

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com/) → My Apps → **+** → New App
2. Fill in:
   - **Platform:** iOS
   - **Name:** Woodlands Fishing
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** select `com.compofelice.WoodlandsFishing` from the dropdown (it appears after Step 3 syncs your dev account)
   - **SKU:** `woodlands-fishing-001` (any unique string)
   - **User Access:** Full Access
3. Then fill App Information:
   - Subtitle (optional, 30 chars)
   - **Category:** Sports (or Navigation / Travel)
   - Privacy Policy URL (see below)
4. **Privacy declaration:** Data collected → Location Data → Used for app functionality, NOT linked to identity, NOT used for tracking.

### Privacy policy

Even free apps require a privacy policy URL. Simplest approaches:
- Free generator: [privacypolicies.com](https://www.privacypolicies.com/) or [termly.io](https://termly.io/)
- Or paste this into a GitHub Pages site (free):

> Woodlands Fishing collects your device location only while the app is open, to display nearby fishing spots and calculate distances. Location data is not stored on any server, not shared with any third party, and not used for tracking or advertising. The app contains no analytics SDKs and no ads. Contact: anthony.compofelice@centricfiber.com

## Step 6 — Archive and upload (~10 min)

In Xcode:

1. Top of the window, click the run destination → choose **"Any iOS Device (arm64)"**. You can't archive for a simulator.
2. Menu: **Product → Archive**. Takes 1-3 min.
3. The Organizer window opens with your archive selected. Click **Distribute App**.
4. **App Store Connect → Upload**. Defaults are fine:
   - Strip Swift symbols: yes
   - Upload symbols: yes
   - Manage version automatically: yes
5. Click Upload. 1-3 min depending on RDP speed.

You'll see "Upload Successful." Wait 5-15 min for Apple to process the build — you'll get an email when it's ready in TestFlight.

## Step 7 — TestFlight beta

In App Store Connect → your app → **TestFlight** tab:

1. Your new build appears, possibly flagged "Missing Compliance" — click it, answer the encryption question (No: no non-exempt encryption), submit.
2. **Internal testers** (no review needed, up to 100):
   - Users and Access → invite team members as Testers
   - Assign them to the "Internal Testing" group on your app
3. **External testers** (up to 10,000, requires a brief beta review — ~1 day):
   - Create an External Testing group, add email addresses

Testers install the TestFlight app on their iPhone, accept the invite, and get the build. You can push updates as often as you want — no review needed for internal testers.

This is where I'd spend a couple weeks before public submission. Invite friends in The Woodlands, fix bugs, refine.

## Step 8 — Submit for App Store review

When you're ready for the public listing:

1. App Store tab → **1.0 Prepare for Submission**
2. Fill in everything:
   - Promotional text (170 chars, optional, can update without a review)
   - **Description** (4000 chars) — what the app does, who it's for, key features
   - **Keywords** (100 chars, comma-separated, no spaces around commas) — e.g.: `fishing,woodlands,texas,bass,lake,permit,catfish,outdoor`
   - **Support URL** — link to a contact page or GitHub Issues
   - Marketing URL (optional)
   - **Screenshots** — drag in 3-10 6.7" iPhone PNGs
   - App icon is auto-pulled from the build
   - **Build** — pick the TestFlight build you uploaded
   - Age rating questionnaire — answer truthfully (yours is 4+)
3. **Submit for Review**

Review typically 24-48 hours. Common first-submission rejections:
- Privacy policy URL broken or vague
- Screenshots don't match the actual app
- Missing justification for location permission in metadata ("Why do you need location?")
- Half-finished features or dead buttons

Fix and resubmit — usually approved the second try.

## Step 9 — Disconnect MacInCloud

Apple menu → Log Out. Pay-As-You-Go stops the meter — unused hours stay in your account.

## Time estimates

| Stage | First time | Subsequent updates |
|---|---|---|
| Mac setup | 15 min | 0 (already configured) |
| Project signing setup | 10 min | 0 |
| App Store Connect record | 20 min | 0 |
| Privacy policy / metadata | 30 min | 5 min (version notes only) |
| Archive + upload | 10 min | 10 min |
| TestFlight wiring | 10 min | 0 |
| **Total** | **~95 min** | **~15 min** |

First submission: ~2 hours of MacInCloud time = ~$2-3 on Pay-As-You-Go. Every update after that is a 15-minute drop-in.
