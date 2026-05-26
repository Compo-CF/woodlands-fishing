#!/usr/bin/env python3
"""Apply geocoded coordinate corrections to Spots.json by spot id."""
import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots_path = root / "WoodlandsFishing" / "Resources" / "Spots.json"
corr_path = root / "scripts" / "coord-corrections.json"

spots_doc = json.loads(spots_path.read_text(encoding="utf-8"))
corrections = json.loads(corr_path.read_text(encoding="utf-8"))
corr_by_id = {c["id"]: c for c in corrections}

changed = 0
moved_far = []
for spot in spots_doc["spots"]:
    c = corr_by_id.get(spot["id"])
    if not c:
        print(f"WARN: no correction for {spot['id']} {spot['name']}")
        continue
    old_lat, old_lon = spot["latitude"], spot["longitude"]
    new_lat, new_lon = c["new"][0], c["new"][1]
    if (old_lat, old_lon) != (new_lat, new_lon):
        changed += 1
        # rough miles moved (1 deg lat ~= 69 mi; lon ~= 60 mi at this latitude)
        dmiles = (((new_lat - old_lat) * 69) ** 2 + ((new_lon - old_lon) * 60) ** 2) ** 0.5
        if dmiles >= 1.0:
            moved_far.append((spot["name"], round(dmiles, 1), c.get("confidence", "?")))
        spot["latitude"] = new_lat
        spot["longitude"] = new_lon

# Write back with stable formatting, preserving unicode (em-dashes, etc.)
spots_path.write_text(
    json.dumps(spots_doc, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8",
)

print(f"Updated {changed} of {len(spots_doc['spots'])} spot coordinates.")
print(f"\nSpots moved >= 1 mile (name, miles, confidence):")
for name, miles, conf in sorted(moved_far, key=lambda x: -x[1]):
    print(f"  {miles:>5} mi  [{conf:>6}]  {name}")
