# Woodlands Fishing

iOS app for finding fishing spots in The Woodlands, TX — with permit/license info and one-tap Apple Maps directions.

## What's in this folder

```
WoodlandsFishing/
├── App/
│   ├── WoodlandsFishingApp.swift      App entry point
│   └── ContentView.swift              Root TabView
├── Models/
│   ├── FishingSpot.swift              Spot data model
│   ├── Enums.swift                    AccessType, Permit, Species, etc.
│   ├── SpotStore.swift                Loads Spots.json, filtering, sorting
│   └── LocationManager.swift          CoreLocation wrapper
├── Views/
│   ├── MapTabView.swift               MapKit map with colored pins
│   ├── ListTabView.swift              Distance-sorted spot list
│   ├── SpotRow.swift                  List row
│   ├── SpotDetailView.swift           Detail screen + directions button
│   ├── PermitsTabView.swift           Reference: TPWD, Township, SJRA, etc.
│   └── FilterBar.swift                Search + filter chips
└── Resources/
    └── Spots.json                     22 seed spots
```

## Development workflow (Windows + cloud Mac)

This project is set up so 95% of the work happens on Windows. The Xcode project is generated from `project.yml` via [XcodeGen](https://github.com/yonaskolb/XcodeGen) — no `.xcodeproj` binary to wrestle with.

### Day-to-day: edit on Windows

1. **Install VS Code** — already? Good. If not, [download](https://code.visualstudio.com/).
2. **Install the Swift extension** — `sswg.swift-lang` in the Extensions panel. Gives you syntax highlighting and basic code intel. (Full autocomplete for UIKit/SwiftUI needs the iOS SDK, which is Mac-only — accept that and move on.)
3. **Optional but nice:** install the *GitHub Actions* and *YAML* extensions for editing the CI workflow.
4. Open the project: `code "C:\Users\anthony.compofelice\WoodlandsFishing"`
5. Edit Swift / JSON / YAML freely. Commit and push.

### Continuous integration: GitHub Actions builds for free

The workflow at `.github/workflows/ios-build.yml` runs on every push to `main`:

- Spins up a `macos-latest` runner
- Installs XcodeGen via Homebrew
- Generates the Xcode project
- Builds for iOS Simulator (no code signing — fast, no certs needed)

You get a green check or a red X within ~3 minutes, so you know whether your Swift compiles **without ever touching a Mac**. Push small, push often.

GitHub macOS-runner minutes burn 10× faster than Linux on the free tier (2000 free Linux minutes = 200 macOS minutes), but that's still ~60 builds/month free.

### Submission day: spin up a cloud Mac (~$1/hr)

When you want to ship a build to TestFlight / App Store:

1. **[MacInCloud](https://www.macincloud.com/)** — pick the *Pay-As-You-Go* plan (~$1/hr) or *Managed Server* (~$30/mo unlimited) if you'll do more iOS work soon. Sign up, you get RDP credentials.
2. RDP in from Windows (use *Remote Desktop Connection*, built into Windows).
3. Once on the Mac:
   ```bash
   # First time only
   brew install xcodegen
   git clone <your-repo-url>
   cd WoodlandsFishing

   # Every time
   git pull
   xcodegen generate
   open WoodlandsFishing.xcodeproj
   ```
4. In Xcode:
   - **Signing & Capabilities** → check *Automatically manage signing* → pick your Apple Developer team (you'll be prompted to sign in once)
   - Set the bundle identifier to something unique (the default `com.compofelice.WoodlandsFishing` is fine if it's available)
5. **Product → Archive** to build a release.
6. **Distribute App → App Store Connect → Upload** — sends it to TestFlight.
7. Add testers in App Store Connect web UI, or submit for App Store review when ready.

### Pre-submission setup (one-time)

- **Apple Developer Program** — $99/year at [developer.apple.com/programs](https://developer.apple.com/programs/). Sign up with your Apple ID. Takes 24–48 hours to activate.
- **App Store Connect** — create your app record at [appstoreconnect.apple.com](https://appstoreconnect.apple.com/) (name, bundle ID, screenshots, description, age rating).
- **App icon** — 1024×1024 PNG required for submission. The placeholder `AppIcon` asset catalog slot is referenced in `project.yml` but you need to add the actual `Assets.xcassets/AppIcon.appiconset` files on the Mac (Xcode helps with this).

### Why XcodeGen instead of a checked-in .xcodeproj

`.xcodeproj` is a directory of weird binary plists. They produce horrible merge conflicts and break when you add files on Windows. `project.yml` is plain YAML — diffable, mergeable, editable on any OS, and `xcodegen generate` rebuilds the project file in <1 second. This is industry standard for serious iOS projects.

## Tech choices

- **SwiftUI** (iOS 17 `@Observable` macro)
- **MapKit** with the new declarative `Map { ... }` syntax
- **CoreLocation** for "near me" sorting
- Apple Maps handoff via `MKMapItem.openInMaps(launchOptions:)` — no custom routing engine needed
- Pure local JSON for spot data (no backend in v1)

## Pin color legend

- 🟢 **Green** — public, open access
- 🟡 **Yellow** — public but limited (e.g., creek-only access, restricted hours)
- 🔴 **Red** — private / no public access (shown for awareness)

## Updating spot data

Edit `Resources/Spots.json` directly. Schema matches `FishingSpot.swift`. UUIDs in the seed file are intentionally stable (`A1B2C3D4-0000-4000-A000-0000000000xx`) so you can add new entries without conflict — pick any valid UUID for new spots.

## Data caveats (from research)

- All lat/lon are **approximate** (nearest park entrance or center of water body). Re-geocode against authoritative sources before public release.
- A handful of named lakes in the area (Mitchell, Mystic, Shadow, Timberloch, Cypress, Alden Bridge, Somerset) are referenced on community angler sites but were not independently verified for manager/access — they're omitted from the seed and should be confirmed before adding.
- Lake Harrison is included as `privateNoAccess` for user awareness — most of its shoreline is commercial/private.
- Permit/license rules change. The "Verify info at source" link on each detail screen is intentional — push users to the authoritative source.

## v2 ideas

- Photos per spot (asset catalog or remote URLs)
- User favorites (UserDefaults or SwiftData)
- "Last fished here" log
- Weather/water conditions overlay
- Submit-a-spot form
- Backend so spot data can update without an app release
