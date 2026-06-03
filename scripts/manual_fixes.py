#!/usr/bin/env python3
"""Apply manual, user-directed coordinate nudges by spot id, then sync to docs."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots_path = root / "WoodlandsFishing" / "Resources" / "Spots.json"
docs_path = root / "docs" / "Spots.json"

# id suffix -> [new_lat, new_lon]  (user-directed moves from satellite-map review)
FIXES = {
    "019": [30.4285, -95.5840],   # Lake Conroe Park: SE toward lake center
    "029": [30.1889, -95.4564],   # Vision Park Pond: SE to center of water
    "050": [30.1699, -95.4863],   # Meadow Lake Pond: NW to water site
    "061": [30.1672, -95.4905],   # Wedgewood Pond: west to center of water
    # Round 2 (after first satellite review):
    "049": [30.1873, -95.4678],   # Mason Pond: move south (overshot the prior +north move)
    "068": [30.145678819120402, -95.55309776842728],  # Twin Ponds Park: EXACT Google Maps coord
    "069": [30.149841641969278, -95.53659855373802],  # Lake Voyageur Pond Park: EXACT Google Maps coord
    "018": [30.0450, -95.4700],   # Spring Creek @ Collins Park: best-effort (was 30.0107)
    "033": [30.1200, -95.4350],   # Lake Holcomb: move west
    "039": [30.1865, -95.5040],   # Shadowpoint Pond: move SE
    "060": [30.1650, -95.4560],   # Venture Tech Pond: best-effort to Huntsman corporate campus
    "064": [30.2030, -95.5625],   # Kirkpatrick Glen Park Pond: move north
    # Mitchell/Monarch/Pondera were placed at 30.07-30.08 by the new agent; user
    # says "very wrong" — moving into the existing Creekside Park cluster (~30.14-30.15):
    "071": [30.1450, -95.5150],   # Mitchell Lake: to Creekside cluster (south edge near Spring Creek)
    "073": [30.1465, -95.5450],   # Monarch Pond Park: to Creekside cluster
    "074": [30.1500, -95.5475],   # Pondera Park Pond: to Creekside cluster
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
