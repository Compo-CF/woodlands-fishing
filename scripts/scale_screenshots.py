#!/usr/bin/env python3
"""Scale 1320x2868 iPhone screenshots down to 1284x2778 for the
App Store Connect 6.5" Display drop-zone."""
from PIL import Image
from pathlib import Path

SRC = Path(r"P:\Digital Products")
OUT = SRC / "scaled"
OUT.mkdir(exist_ok=True)
TARGET = (1284, 2778)  # iPhone 6.5" Display @3x portrait

count = 0
for png in sorted(SRC.glob("IMG_*.PNG")):
    img = Image.open(png)
    resized = img.resize(TARGET, Image.LANCZOS)
    out_path = OUT / png.name
    resized.save(out_path, format="PNG", optimize=True)
    count += 1
    print(f"  {png.name}: {img.size} -> {resized.size}  ({out_path})")

print(f"\nWrote {count} scaled screenshots to {OUT}")
