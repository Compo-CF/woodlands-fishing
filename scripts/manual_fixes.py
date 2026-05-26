#!/usr/bin/env python3
"""Apply manual, user-directed coordinate nudges by spot id, then sync to docs."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots_path = root / "WoodlandsFishing" / "Resources" / "Spots.json"
docs_path = root / "docs" / "Spots.json"

# id suffix -> [new_lat, new_lon]  (user-directed moves from satellite-map review)
FIXES = {
    "019": [30.4285, -95.5840],  # Lake Conroe Park: SE toward lake center
    "049": [30.1913, -95.4678],  # Mason Pond: a little north
    "029": [30.1889, -95.4564],  # Vision Park Pond: SE to center of water
    "061": [30.1672, -95.4905],  # Wedgewood Pond: west to center of water
    "050": [30.1699, -95.4863],  # Meadow Lake Pond: NW to water site
    "068": [30.1441, -95.5532],  # Twin Ponds Park: move south
}

doc = json.loads(spots_path.read_text(encoding="utf-8"))
hits = 0
for s in doc["spots"]:
    suffix = s["id"].split("-")[-1][-3:]
    if suffix in FIXES:
        old = (s["latitude"], s["longitude"])
        s["latitude"], s["longitude"] = FIXES[suffix]
        print(f"  {s['name']}: {old} -> ({s['latitude']}, {s['longitude']})")
        hits += 1

spots_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
docs_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"\nApplied {hits} manual fixes; synced bundled + docs copies.")
