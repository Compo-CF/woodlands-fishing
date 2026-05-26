#!/usr/bin/env python3
"""Generate a satellite verification map (verify-map.html) from Spots.json.
Plots every spot on Esri World Imagery so we can confirm pins land on water."""
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
spots = json.loads((root / "WoodlandsFishing" / "Resources" / "Spots.json").read_text(encoding="utf-8"))["spots"]

# Minimal payload for the map
pts = [
    {
        "n": s["name"],
        "lat": s["latitude"],
        "lon": s["longitude"],
        "a": s["access"],
        "wb": s["waterBodyType"],
    }
    for s in spots
]

html = """<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<title>Woodlands Fishing — Coordinate Verification (Satellite)</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<style>
  html,body{margin:0;height:100%;font-family:-apple-system,Segoe UI,sans-serif}
  #map{position:absolute;inset:0}
  .legend{position:absolute;top:10px;right:10px;z-index:1000;background:rgba(255,255,255,.92);
    padding:10px 12px;border-radius:8px;font-size:12px;box-shadow:0 2px 8px rgba(0,0,0,.3);line-height:1.6}
  .legend b{font-size:13px}
  .dot{display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:6px;border:1px solid #fff}
  .lbl{font-size:11px;font-weight:600;color:#fff;text-shadow:0 0 3px #000,0 0 3px #000;white-space:nowrap}
</style></head><body>
<div id="map"></div>
<div class="legend">
  <b>Coordinate verification</b><br>
  <span class="dot" style="background:#34C759"></span>public<br>
  <span class="dot" style="background:#FFCC00"></span>public (limited)<br>
  <span class="dot" style="background:#FF3B30"></span>private<br>
  <hr style="margin:6px 0;border:none;border-top:1px solid #ccc">
  Each pin should sit ON a pond/lake.<br>Click a pin for its name.
</div>
<script>
const PTS = __DATA__;
const color = a => a==='publicOpen' ? '#34C759' : a==='publicLimited' ? '#FFCC00' : '#FF3B30';
const map = L.map('map');
L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  {maxZoom:19, attribution:'Esri World Imagery'}).addTo(map);
// Bounding box: FM2978 / I-45 / FM1488 / Grand Pkwy
L.rectangle([[30.06,-95.56],[30.21,-95.42]], {color:'#00e5ff',weight:2,fill:false,dashArray:'6 6'}).addTo(map);
const group = [];
PTS.forEach(p => {
  const m = L.circleMarker([p.lat,p.lon], {radius:7,color:'#fff',weight:2,fillColor:color(p.a),fillOpacity:1})
    .addTo(map).bindPopup('<b>'+p.n+'</b><br>'+p.lat.toFixed(4)+', '+p.lon.toFixed(4)+'<br>'+p.wb+' · '+p.a);
  m.bindTooltip(p.n, {permanent:true, direction:'right', className:'lbl', offset:[8,0]});
  group.push(m);
});
map.fitBounds(L.featureGroup(group).getBounds().pad(0.08));
</script></body></html>"""

html = html.replace("__DATA__", json.dumps(pts, ensure_ascii=False))
out = root / "verify-map.html"
out.write_text(html, encoding="utf-8")
print(f"Wrote {out} with {len(pts)} pins.")
