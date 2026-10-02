# The Woodlands Fishing Guide — v2.0 Design System

> **Direction:** Field Guide — Audubon Bird Guide × National Parks poster.
> Warm, naturalist, hand-made. The opposite of Fishbrain/iFish (both go
> modern-dark-outdoor). Elevates the "81 spots curated by a local, not a
> database" story and makes the Tip Jar read as supporting a passion project.
>
> **Scope:** Full visual overhaul + per-spot photos + richer spot data +
> TPWD stocking + USGS gauge integration. Ships as **v2.0 (build 13)**.
>
> This file is the source of truth across design sessions. Mockups go in
> `design/mockups/`.

---

## 1. Palette (8 colors)

Light-mode values. Dark-mode counterparts in table 1b.

| Token          | Role                             | Hex       | Notes                              |
| -------------- | -------------------------------- | --------- | ---------------------------------- |
| `deep.lake`    | Primary brand, CTAs, section nav | `#0F3B4C` | Deep, muted lake-water teal        |
| `pine`         | Secondary accent, borders, chips | `#2E4A3B` | Dark forest green                  |
| `amber`        | Highlight accent, warm emphasis  | `#D97E2A` | Sunset / fall-leaf orange          |
| `bone`         | App background, hero text        | `#F7F1E3` | Field-journal cream                |
| `kraft`        | Card surface, chip bg            | `#E8DFC9` | Warm tan paper tone                |
| `ink`          | Primary text                     | `#1A1A1A` | Near-black, slightly warm          |
| `slate`        | Secondary text, hairline borders | `#5C6670` | Soft grey-blue                     |
| `rust`         | Alert / warning / restrictions   | `#B04A2A` | Deep terracotta                    |

### 1b. Dark-mode counterparts

| Token          | Dark hex  | Notes                              |
| -------------- | --------- | ---------------------------------- |
| `deep.lake`    | `#8EC8D8` | Flips to light accent on dark bg   |
| `pine`         | `#8FB89A` | Muted sage                         |
| `amber`        | `#F2A868` | Warmer, pulled toward daylight     |
| `bone`         | `#15191C` | True deep ink, not pure black      |
| `kraft`        | `#242A2F` | Charcoal surface                   |
| `ink`          | `#F2EEE2` | Bone text on dark                  |
| `slate`        | `#8891A0` | Lighter in dark mode               |
| `rust`         | `#E68458` | Softens on dark                    |

### Usage rules

- **Backgrounds:** `bone` only. Never pure white. Cards sit on `bone` with `kraft` or `kraft@40%` fill.
- **Primary action:** `deep.lake` background, `bone` text, `Fraunces 600`.
- **Secondary action:** 1pt `pine` border, `ink` text, transparent bg.
- **Destructive / warning:** `rust` text or outline — never fill, this is a tipjar app not a warning app.
- **Links:** `pine` text + 1px underline.
- **Favorite icon:** `amber`, not pink. The pink heart from v1.x is retired.

---

## 2. Typography

Three faces. Fraunces is loaded as a bundled font; SF Pro Text and SF Mono are built-in on iOS.

| Face              | Role                                | Rationale                              |
| ----------------- | ----------------------------------- | -------------------------------------- |
| **Fraunces**      | Display, section titles, big numbers | Variable serif with field-journal character; modern but warm |
| **SF Pro Text**   | Body, UI chrome                     | Native, free, perfect iOS rendering    |
| **SF Mono**       | Coordinates, pressure, times, data  | Monospaced disambiguates numeric data  |

### Scale

| Name           | Face        | Size | Weight | Tracking | Line Height | Usage                         |
| -------------- | ----------- | ---- | ------ | -------- | ----------- | ----------------------------- |
| display-xl     | Fraunces    | 34   | 600    | -0.5     | 38          | Spot name over hero           |
| display-l      | Fraunces    | 24   | 600    | -0.3     | 28          | Section big-number (temp, stock date) |
| display-m      | Fraunces    | 20   | 600    | -0.2     | 24          | Card titles                   |
| body-l         | SF Pro Text | 17   | 400    | 0        | 22          | Long-form reading             |
| body           | SF Pro Text | 15   | 400    | 0        | 20          | Default body                  |
| body-med       | SF Pro Text | 15   | 500    | 0        | 20          | Emphasized body               |
| caption        | SF Pro Text | 13   | 500    | 0        | 16          | Secondary labels              |
| micro-label    | SF Pro Text | 11   | 600    | 1.5      | 14          | Section eyebrow labels (UPPERCASE: "01 — CURRENT CONDITIONS") |
| mono           | SF Mono     | 15   | 500    | 0        | 20          | Numeric data (30.12 inHg)     |
| mono-small     | SF Mono     | 12   | 500    | 0        | 16          | Caption-sized data            |

### Rules

- **Always pair a Fraunces heading with a micro-label.** The eyebrow carries the section number ("01 —", "02 —"); the serif carries the content.
- **No all-caps Fraunces.** Serif + uppercase looks dated. Caps live in micro-label only.
- **Numeric data uses SF Mono.** Weather values, coordinates, times, dates, prices. Prevents misalignment in cards.

---

## 3. Spacing scale

Base: 4pt grid. Named tokens:

| Token    | pt | Common use                            |
| -------- | -- | ------------------------------------- |
| `xs`     | 4  | Icon-to-text gap                      |
| `sm`     | 8  | Dense inline rhythm                   |
| `md`     | 12 | Card interior padding (small)         |
| `lg`     | 16 | Standard card padding                 |
| `xl`     | 20 | Section interior                      |
| `2xl`    | 24 | Between stacked cards                 |
| `3xl`    | 32 | Between sections                      |
| `4xl`    | 40 | Hero → first section                  |
| `5xl`    | 56 | Dramatic breathing (About screen)     |
| `6xl`    | 72 | Only around hero screens              |

---

## 4. Corner radii

| Token   | pt   | Use                              |
| ------- | ---- | -------------------------------- |
| `r-xs`  | 4    | Mini chips, inline tags          |
| `r-sm`  | 8    | Buttons, badges                  |
| `r-md`  | 12   | Standard cards                   |
| `r-lg`  | 16   | Primary cards (WeatherCard etc.) |
| `r-xl`  | 24   | Hero-adjacent surfaces           |
| `pill`  | 999  | Pills, chips                     |

---

## 5. Borders & shadows

**Shadows are forbidden.** Field Guide feel = flat paper, not elevated glass.

Use **hairline borders** instead:

| Token             | Width | Color                   | Use                                 |
| ----------------- | ----- | ----------------------- | ----------------------------------- |
| `hairline-soft`   | 0.5pt | `slate` @ 15%           | Default card separation             |
| `hairline`        | 1pt   | `slate` @ 25%           | Card border                         |
| `hairline-ink`    | 1pt   | `ink`                   | Emphasis — "important" surfaces     |
| `rule-ink`        | 2pt   | `ink`                   | Section rules, hand-drawn-feel      |

Hero image → content transition uses a **deckle edge** (irregular organic-feeling border, not a hard line) rendered as a 24pt-tall gradient from hero image to bone.

---

## 6. Components

### FieldCard
- Background: `kraft` (or `kraft@40%` on complex screens)
- Border: `hairline` all sides
- Padding: `lg` (16pt) default, `xl` on primary cards
- Corner: `r-md` (12pt) default, `r-lg` on primary
- No shadow. No gradient.

### FieldBadge
- Shape: pill
- Border: 1pt `pine`
- Fill: transparent
- Text: `ink`, `caption` weight 600
- Padding: 10pt horizontal, 5pt vertical
- Optional leading icon: 11pt, `pine` tint

### FieldChip (species, filter)
- Shape: `r-sm` (8pt), not pill
- Fill: `kraft`
- Border: `hairline`
- Text: `caption`
- Optional 16pt line-illustration icon on left

### FieldButton (primary)
- Fill: `deep.lake`
- Text: `bone`, Fraunces 500, `display-m` size for CTAs
- Corner: `r-sm` (8pt)
- Padding: 16pt vertical, 24pt horizontal

### FieldButton (secondary)
- Fill: transparent
- Border: 1pt `pine`
- Text: `ink`

### SectionHeader
- Micro-label eyebrow: "01 — CURRENT CONDITIONS"
- Fraunces title below: "Today on the water"
- `hairline-ink` rule above the eyebrow, extending full width
- Spacing: `3xl` above, `md` below

### HeroImage
- Full-bleed watercolor illustration (or user photo when `coverPhotoURL` set)
- Height: 60% of screen on SpotDetail
- Deckle-edge bottom transition
- Translucent nav overlay (bone@70%, blur) at top
- Title + access badge overlap bottom (negative margin -40pt)

### WeatherCard (new treatment)
- `kraft` bg, `r-lg`, `hairline` border
- Row 1: Big Fraunces `display-l` current temp + `body-med` condition + SF Symbol weather icon
- Row 2: 2x2 mono grid of pressure / wind / sunrise / sunset
- Row 3: `caption` secondary — "Updated 2:43 PM via Open-Meteo"

### DataRow
- Micro-label eyebrow (left-aligned)
- Mono value below (`display-l` for big numbers, `mono` for inline)

---

## 7. Illustration system

### Hero cover art
Each spot gets a watercolor-style stylized illustration — layered gradients mimicking a lake / pond / creek scene. Not literal, atmospheric. Palette-constrained to Field Guide colors.

- **Dimensions:** 1290×1680 (fits above the content fold on SpotDetail)
- **File:** PNG, served from `docs/covers/<spot-slug>.png`
- **Fallback:** procedural gradient if no cover file exists for a spot
- **Override:** if `coverPhotoURL` set, user photo displaces the illustration

### Species silhouettes
Simple line-illustration (2pt stroke, `ink` on `kraft`) of each of the 8 species, side profile, tasteful not technical. Used in filter chips (16pt), SpotDetail species list (24pt), species detail (full width if we ever add that).

### Map pins
4 custom pin designs — one per `AccessType`:
- `publicOpen` — field-journal pin, `pine` fill, bone fish silhouette inside
- `publicLimited` — same silhouette, `amber` fill
- `privateContact` — same silhouette, hollow, `slate` outline
- `privateNoAccess` — small X-marked pin, `rust` outline

Favorited spots get an `amber` heart badge pinned to the top-right of the pin.

---

## 8. Dark mode

All tokens have dark variants (table 1b). Illustrations are rendered on `bone` background and clipped — in dark mode, the hero area blends into `bone` dark (`#15191C`) with the illustration slightly desaturated. No separate dark illustrations needed for v2.0.

---

## 9. Reference apps / inspiration

- **Audubon Bird Guide** — field-guide authority + warm palette
- **National Park Service posters (WPA era)** — illustrated hero compositions, strong palette discipline
- **Monocle magazine** — serif + sans pairing, micro-label eyebrow typography
- **Field Notes brand** — kraft/bone/pine palette logic, tactile paper feel

---

## 10. Data schema additions (v2.0)

New fields on each FishingSpot (defined in `WoodlandsFishing/Models/`, backed by `WoodlandsFishing/Resources/Spots.json` + `docs/Spots.json`). Dates stored as ISO-8601 strings per existing Codable convention. All new fields are optional for backward compatibility with v1.x cached data.

```swift
let coverPhotoURL: URL?            // user-contributed photo override; nil = use illustration
let shadeLevel: ShadeLevel?        // enum: none, partial, full
let kidFriendly: Bool              // default false
let familyNotes: String?
let bathroomType: BathroomType?    // enum: none, portable, permanent
let launchFee: String?             // free-form text, e.g. "$5" or "free"
let bestSeasonMonths: [Int]        // 1-12, e.g. [3,4,5,10,11] for spring+fall
let lastStockedDate: Date?         // populated by TPWD scraper, CFL spots only
let usgsGaugeID: String?           // e.g. "08068090" for Spring Creek near Spring
```

---

## 11. Open design decisions (to lock before Phase 5)

- Final selection of species silhouette art style (woodcut vs line drawing vs plate illustration)
- Final hero illustration treatment per spot — one generic treatment per water-body-type, or per-spot composed
- Map pin size (currently proposed 32pt base, 44pt favorited)
- Onboarding animation style — static illustrated plates with fade, or small embedded animations

---

**Approval checkpoint:** this spec is approved implicitly when the SpotDetail
mockup produced alongside it (`design/mockups/spot-detail-lake-woodlands.png`)
is approved. Any changes to palette, type, or component rules require updating
this file first before touching Swift.
