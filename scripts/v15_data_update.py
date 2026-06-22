#!/usr/bin/env python3
"""v1.5 data update: add 7 new spots and update Lake Conroe Park's metadata
to reflect its 2025 reopening as 'Lake Conroe Beach Park' under a private
operator."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots_path = root / "WoodlandsFishing" / "Resources" / "Spots.json"
docs_path = root / "docs" / "Spots.json"

# --- Update Lake Conroe Park (id 019) to reflect 2025 reopening ---
LAKE_CONROE_ID = "A1B2C3D4-0000-4000-A000-000000000019"
LAKE_CONROE_UPDATE = {
    "name": "Lake Conroe Beach Park (formerly Lake Conroe Park)",
    "manager": "SJRA (leased to 1097 Watersports — private operator)",
    "access": "publicLimited",
    "parkingNotes": "Reopened May 2025 after 17-month closure. Now operated as a beach park with cabana rentals and fees. Confirm current bank-fishing rules with the operator before visiting.",
    "restrictions": "Now a fee-based beach concept. Largemouth bass 16\" minimum (vs. 14\" statewide). 5-fish daily bag for all black bass combined. Grass carp catch-and-release only.",
    "description": "Reopened May 2025 as Lake Conroe Beach Park under private management (1097 Watersports / Herbert family). New beach + cabana amenities; fishing access semantics differ from the pre-2024 Lake Conroe Park.",
    "sourceURL": "https://communityimpact.com/houston/the-woodlands/government/2025/05/27/lake-conroe-beach-park-officially-reopens-with-new-leadership-amenities/",
}

# --- 7 NEW spots ---
NEW_SPOTS = [
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000075",
        "name": "Wendtwoods Park Lake",
        "latitude": 30.084,
        "longitude": -95.524,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "lake",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "bluegill", "channelCatfish"],
        "parkingNotes": "Wendtwoods Park, Creekside Park Village (approx — verify on-device).",
        "restrictions": "Catch-and-release only.",
        "description": "Township neighborhood lake in southern Creekside Park.",
        "sourceURL": "https://www.thewoodlandstownship-tx.gov/Departments/Parks-Recreation/Parks/Parks/Creekside-Park-Parks/Wendtwoods-Park",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000076",
        "name": "Smooth Stream Park Pond",
        "latitude": 30.085,
        "longitude": -95.520,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "bluegill"],
        "parkingNotes": "Smooth Stream Park, Creekside Park Village (approx).",
        "restrictions": "Catch-and-release only.",
        "description": "Township greenbelt pond in Creekside Park.",
        "sourceURL": "https://www.visitthewoodlands.com/listing/smooth-stream-park/2515/",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000077",
        "name": "Tupelo Park Pond",
        "latitude": 30.092,
        "longitude": -95.532,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "kayakCanoe",
        "species": ["largemouthBass", "bluegill", "channelCatfish"],
        "parkingNotes": "Tupelo Park, Creekside Park Village (approx).",
        "restrictions": "Catch-and-release only.",
        "description": "Township park pond with kayak/canoe access in Creekside Park.",
        "sourceURL": "https://www.thewoodlandstownship-tx.gov/Departments/Parks-Recreation/Parks/Parks/Creekside-Park-Parks/Tupelo-Park",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000078",
        "name": "Timarron Pond Park",
        "latitude": 30.094,
        "longitude": -95.527,
        "manager": "The Woodlands Township (Creekside Park)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "bluegill"],
        "parkingNotes": "Timarron Pond Park, Creekside Park Village (approx).",
        "restrictions": "Catch-and-release only.",
        "description": "Township greenbelt pond in Creekside Park.",
        "sourceURL": "https://www.thewoodlandstownship-tx.gov/facilities/facility/details/Timarron-Pond-Park-178",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000079",
        "name": "Dennis Johnston Park Pond",
        "latitude": 30.071,
        "longitude": -95.395,
        "manager": "Harris County Precinct 4 (TPWD Community Fishing Lake)",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": False,
        "bankFishing": True,
        "boatAccess": "kayakCanoe",
        "species": ["channelCatfish", "largemouthBass", "crappie", "whiteBass", "bluegill"],
        "parkingNotes": "709 Riley Fuzzel Rd. TPWD-stocked Community Fishing Lake. Kayak launch onto Spring Creek nearby.",
        "restrictions": "TPWD CFL rules apply.",
        "description": "Harris County Pct 4 park on Spring Creek with a stocked pond. Part of the TPWD Community Fishing Lakes program.",
        "sourceURL": "https://hcp4.wordpress.com/parks/dennisjohnston/",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000080",
        "name": "Hart Pundt Lake",
        "latitude": 30.061,
        "longitude": -95.402,
        "manager": "Harris County Precinct 4 (TPWD Community Fishing Lake)",
        "waterBodyType": "lake",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": False,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["largemouthBass", "bluegill", "channelCatfish"],
        "parkingNotes": "Inside Pundt Park (4129 Spring Creek Dr) — the named lake, distinct from the Spring Creek bank-access entry.",
        "restrictions": "TPWD CFL rules apply.",
        "description": "Named lake inside Pundt Park, regularly stocked by TPWD. Different from the Spring Creek bank access at the same park.",
        "sourceURL": "https://tpwd.texas.gov/fishboat/fish/action/stock_bywater.php?WB_code=1351",
    },
    {
        "id": "A1B2C3D4-0000-4000-A000-000000000081",
        "name": "Bluegill Pond (Spring Creek Greenway Nature Center)",
        "latitude": 30.072,
        "longitude": -95.396,
        "manager": "Montgomery County Precinct 3 / Spring Creek Greenway Nature Center",
        "waterBodyType": "pond",
        "access": "publicOpen",
        "permitsRequired": ["tpwdFreshwater"],
        "catchAndReleaseOnly": True,
        "bankFishing": True,
        "boatAccess": "none",
        "species": ["bluegill", "channelCatfish", "largemouthBass"],
        "parkingNotes": "Spring Creek Greenway Nature Center. Boardwalk and observation deck access.",
        "restrictions": "Catch-and-release only.",
        "description": "Small stocked pond at the Spring Creek Greenway Nature Center, with boardwalk access for kid/family-friendly fishing.",
        "sourceURL": "https://www.woodlandsonline.com/npps/story.cfm?nppage=76198",
    },
]

doc = json.loads(spots_path.read_text(encoding="utf-8"))

# Apply the Lake Conroe Park update
updated = 0
for spot in doc["spots"]:
    if spot["id"] == LAKE_CONROE_ID:
        old_name = spot["name"]
        spot.update(LAKE_CONROE_UPDATE)
        updated += 1
        print(f"  UPDATED {old_name} -> {spot['name']}")

# Append new spots (skip if id already exists)
existing_ids = {s["id"] for s in doc["spots"]}
appended = 0
for new in NEW_SPOTS:
    if new["id"] in existing_ids:
        print(f"  skip (exists): {new['name']}")
        continue
    doc["spots"].append(new)
    appended += 1
    print(f"  + {new['name']} @ {new['latitude']}, {new['longitude']}")

# Persist
spots_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
docs_path.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

print(f"\nUpdated {updated} existing spot(s); appended {appended} new. Total now: {len(doc['spots'])}.")
