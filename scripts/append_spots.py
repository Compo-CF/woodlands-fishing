#!/usr/bin/env python3
"""Append additional verified spots to Spots.json (and sync to docs/)."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots_path = root / "WoodlandsFishing" / "Resources" / "Spots.json"
docs_path = root / "docs" / "Spots.json"

NEW = [
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000070",
        "name": "Bedias Lake",
        "latitude": 30.156,
        "longitude": -95.519,
        "manager": "The Woodlands Township (George Mitchell Nature Preserve)",
        "waterBodyType": "lake",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "kayakCanoe",
        "species": ["largemouthBass", "channelCatfish", "spottedGar"],
        "parkingNotes": "Flintridge Drive trailhead between Falconwing and Gosling; ~0.5-mile hike to the lake.",
        "restrictions": "Catch-and-release only. No motors, no boat ramp. Hike-in via George Mitchell Nature Preserve trails.",
        "description": "Hike-in lake inside George Mitchell Nature Preserve. Wild, low-traffic for the bank angler willing to walk.",
        "sourceURL": "https://www.fishinginthewoodlands.com/bedias-lake",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000071",
        "name": "Mitchell Lake",
        "latitude": 30.072,
        "longitude": -95.522,
        "manager": "The Woodlands Township (Spring Creek Greenway / Creekside Park)",
        "waterBodyType": "lake",
        "access": "publicLimited",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": False,
        "boatAccess": "kayakCanoe",
        "species": ["largemouthBass", "bluegill", "crappie"],
        "parkingNotes": "Kayak launch off Creekside Forest Dr, ~0.25 mi east of Gosling. Dirt road may be impassable after rain.",
        "restrictions": "Catch-and-release only. Kayak/canoe only — swampy edges, no real bank fishing. Alligator and snake warnings posted.",
        "description": "Spring Creek oxbow with a small kayak-launch dock. Wild setting; come prepared.",
        "sourceURL": "https://www.fishinginthewoodlands.com/mitchell-lake",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000072",
        "name": "The Cove (Lake Woodlands arm)",
        "latitude": 30.176,
        "longitude": -95.498,
        "manager": "The Woodlands Township (Lake Woodlands inlet)",
        "waterBodyType": "lake",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": False,
        "bankFishing": True,
        "boatAccess": "kayakCanoe",
        "species": ["channelCatfish", "crappie", "bluegill"],
        "parkingNotes": "Walk-in via street parking; small dock and footbridge.",
        "restrictions": None,
        "description": "Quiet inlet/arm of Lake Woodlands. Catch-and-keep allowed since it's part of Lake Woodlands.",
        "sourceURL": "https://www.fishinginthewoodlands.com/the-cove",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000073",
        "name": "Monarch Pond Park",
        "latitude": 30.078,
        "longitude": -95.524,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "bluegill"],
        "parkingNotes": "Neighborhood park in Creekside Park Village (approximate; verify on-device).",
        "restrictions": "Catch-and-release only.",
        "description": "Township neighborhood pond in Creekside Park.",
        "sourceURL": "https://www.thewoodlandstownship-tx.gov/Departments/Parks-Recreation/Parks/Parks/Creekside-Park-Parks/Monarch-Pond-Park",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000074",
        "name": "Pondera Park Pond",
        "latitude": 30.080,
        "longitude": -95.519,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "crappie"],
        "parkingNotes": "Park with pavilion and playground; bankside fishing (approximate; verify on-device).",
        "restrictions": "Catch-and-release only.",
        "description": "Family-friendly park pond in Creekside Park.",
        "sourceURL": "https://fishbrain.com/fishing-waters/hSy4XLr9/pondera-park-ponds",
    },
]

doc = json.loads(spots_path.read_text(encoding="utf-8"))
existing_ids = {s["id"] for s in doc["spots"]}
appended = 0
for spot in NEW:
    if spot["id"] in existing_ids:
        print(f"  skip (already exists): {spot['name']}")
        continue
    doc["spots"].append(spot)
    appended += 1
    print(f"  + {spot['name']} @ {spot['latitude']}, {spot['longitude']}")

spots_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
docs_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"\nAppended {appended} spots. Total now: {len(doc['spots'])}.")
