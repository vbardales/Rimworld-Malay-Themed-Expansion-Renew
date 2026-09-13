import json, math
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[1]
art=root/"Art"
layout=json.loads((art/"preview-layout-qa.json").read_text())
bg=Image.open(art/"Preview-background-qa.png").convert("RGB")
def luminance(rgb):
    c=[v/255 for v in rgb]
    c=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in c]
    return .2126*c[0]+.7152*c[1]+.0722*c[2]
def contrast(a,b):
    x,y=sorted([luminance(a),luminance(b)])
    return (y+.05)/(x+.05)
report={}
for name,r in layout["rects"].items():
    if name=="#version": continue
    ink=tuple(int(v.strip()) for v in r["color"].removeprefix("rgb(").removesuffix(")").split(","))
    box=(max(0,math.floor(r["x"])),max(0,math.floor(r["y"])),min(896,math.ceil(r["x"]+r["width"])),min(504,math.ceil(r["y"]+r["height"])))
    report[name]=round(min(contrast(ink,p) for p in bg.crop(box).getdata()),2)
p=json.loads((art/"preview-palette.json").read_text())
hexrgb=lambda v:tuple(bytes.fromhex(v[1:]))
report["badge"]=round(contrast(hexrgb(p["accent"]),hexrgb(p["badgeInk"])),2)
assert min(report.values())>=4.5, report
Image.open(root/"Mod/About/Preview.png").resize((268,151),Image.Resampling.LANCZOS).save(art/"Preview-thumbnail-qa.png")
Image.open(root/"Mod/About/ModIcon.png").resize((32,32),Image.Resampling.LANCZOS).save(art/"ModIcon-thumbnail-qa.png")
(art/"preview-contrast-qa.json").write_text(json.dumps(report,indent=2)+"\n")
print(report)