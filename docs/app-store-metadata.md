# App Store Metadata Draft

Drafts for the fields you'll fill in App Store Connect. Edit before submission. Character limits are Apple's hard caps.

---

## App name (App Store Connect → App Information)
**Woodlands Fishing**
*(or whatever name you registered if "Woodlands Fishing" was taken)*

## Subtitle (30 character limit)
**Fishing spots in The Woodlands** — 30 chars exactly ✓

*Alternates if you'd rather:*
- `Spots, permits & directions` (27)
- `Bass, bream, catfish nearby` (27)
- `Find fishing spots near you` (27)

## Promotional text (170 chars — editable anytime without review)
> Every public fishing spot around The Woodlands, TX — with permit rules, species notes, and one-tap directions to 22 verified locations.

(132 chars, leaves room to add seasonal notes later like "Spring white-bass run is on at Pundt Park")

## Description (4000 char limit, plain text only)

```
A focused guide to fishing in and around The Woodlands, Texas.

Find 22 verified spots — from Township-managed ponds like Lake Paloma and Bear Branch Reservoir, to Spring Creek bank access at Pundt Park, to Lake Conroe public boat ramps — with the permit rules and species notes you actually need.

WHAT'S INSIDE
• Live map with every spot color-coded by access type
• Distance-sorted list with one-tap Apple Maps directions
• Permits & rules tab covering Texas freshwater license, Township pond rules, Lake Conroe special regulations, and W.G. Jones State Forest
• Filters for public-only, catch-and-keep allowed, bank access, boat access
• Source links on every spot — verify the rules at the official source before you fish

WHO IT'S FOR
Whether you're a Woodlands resident scouting your village ponds, a visitor heading to Lake Conroe, or new to the area and wondering where you can legally drop a line — this app gives you a clean answer without the guesswork.

WHAT'S NOT INSIDE
No social feed. No leaderboards. No subscription. No advertising. No data collection beyond your live location, which never leaves your device.

A NOTE ON PERMITS
Fishing rules change. Each spot links directly to the authoritative source so you can verify before fishing.

SPOTS COVERED
• Lake Woodlands (Northshore and Southshore Park access)
• Lake Paloma at Creekside Park
• Bear Branch Reservoir
• 10 additional Township ponds and parks across The Woodlands
• Spring Creek public access at Pundt Park, Jesse H. Jones Park, and Collins Park
• Lake Conroe (Lake Conroe Park, Scott's Ridge, FM 830 ramp, Stubblefield)
• W.G. Jones State Forest ponds
```

## Keywords (100 char limit, comma-separated, NO spaces after commas)
```
fishing,woodlands,texas,bass,lake,conroe,tpwd,permit,catfish,bream,crappie,spots,outdoor,map
```
(94 chars ✓)

## Support URL
`https://github.com/Compo-CF/woodlands-fishing/issues`

(Or set up a simple contact page. GitHub Issues works fine for a free app.)

## Marketing URL (optional, can leave blank)
Skip for v1.0.

## Privacy Policy URL
`https://compo-cf.github.io/woodlands-fishing/privacy.html`

(Becomes live after you enable GitHub Pages — see README in this folder.)

## Category
- **Primary:** Sports
- **Secondary:** Travel *(optional — adds discoverability)*

## Age Rating
**4+** (no objectionable content)

## Price tier
**Free**

## Copyright
`© 2026 Anthony Compofelice`

---

## App Privacy declaration (App Store Connect → App Privacy)

When Apple asks you the privacy questionnaire, answer like this:

**Q: Does your app collect data from this app?**
→ **Yes**

**Q: What data does your app collect?**
→ Check only: **Location → Precise Location**

**For Precise Location, answer:**
- **Is the data linked to the user's identity?** → **No**
- **Is the data used for tracking purposes?** → **No**
- **What is this data used for?** → check only **App Functionality**
- **Is the collection of this data optional?** → **No** (it's required for the core map/distance feature, though the user can deny the permission and the app still works in a degraded mode)

That's it. No other data categories apply.

---

## TestFlight "What to Test" notes (for the first beta build)

```
Initial v1.0 build. Please test:

• Map loads with 22 colored pins around The Woodlands
• Tapping a pin opens the detail sheet with permit/species info
• "Directions in Apple Maps" successfully hands off and starts navigation
• Spots list sorts correctly by distance from your location
• Filter chips correctly narrow the spot list
• Permits tab opens and reference cards are readable
• Location permission prompt shows the correct usage description

Please report any incorrect spot coordinates, outdated permit info, or spots I missed in The Woodlands area.
```

---

## Screenshots needed (do these on the Mac after first build)

**Required: 6.7" iPhone (1290 × 2796 px PNG) — at minimum 3, up to 10**
Best plan: take 5 from the simulator running your app on iPhone 15/16 Pro Max:
1. Map tab — full Woodlands view with all pins visible
2. Spot detail sheet — Lake Paloma open
3. Spot detail sheet — different spot with C&R warning visible
4. Spots list — distance-sorted view
5. Permits tab — reference cards

**Optional but recommended: 6.5" iPhone (1242 × 2688 or 1284 × 2778 px)** — Apple auto-shows the 6.7" set if you only provide that, but having both helps a tiny bit.

Apple no longer requires iPad screenshots if your app is iPhone-only (`TARGETED_DEVICE_FAMILY: 1` in `project.yml` is already set).
