#!/usr/bin/env python3
"""E-OS: малює фон екрана завантаження. Використання: make_boot_splash.py OUT.png W H"""
import sys, os
from PIL import Image, ImageDraw, ImageFont, ImageEnhance, ImageFilter

out, W, H = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
here = os.path.dirname(os.path.abspath(__file__))

def font(size, bold=True):
    for p in ("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"):
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    try:
        return ImageFont.load_default(size)
    except TypeError:
        return ImageFont.load_default()

# фон: шпалери E-OS, затемнені й трохи розмиті
bg = Image.open(os.path.join(here, "wallpaper.jpg")).convert("RGB")
scale = max(W / bg.width, H / bg.height)
bg = bg.resize((int(bg.width * scale) + 1, int(bg.height * scale) + 1), Image.LANCZOS)
bg = bg.crop(((bg.width - W) // 2, (bg.height - H) // 2, (bg.width - W) // 2 + W, (bg.height - H) // 2 + H))
bg = ImageEnhance.Brightness(bg.filter(ImageFilter.GaussianBlur(2))).enhance(0.45)

# затемнення знизу, де буде текст меню
shade = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(shade)
for y in range(int(H * 0.40), H):
    a = int(150 * (y - H * 0.40) / (H * 0.60))
    d.line([(0, y), (W, y)], fill=(0, 12, 0, a))
img = Image.alpha_composite(bg.convert("RGBA"), shade)

# логотип + назва
logo = Image.open(os.path.join(here, "logo-white.png")).convert("RGBA")
ls = int(H * 0.20)
logo = logo.resize((ls, ls), Image.LANCZOS)
x0, y0 = int(W * 0.07), int(H * 0.08)
img.alpha_composite(logo, (x0, y0))
d = ImageDraw.Draw(img)
tx = x0 + ls + int(W * 0.03)
d.text((tx, y0 + int(ls * 0.05)), "E-OS", font=font(int(H * 0.115)), fill=(255, 255, 255, 255))
d.text((tx + 2, y0 + int(ls * 0.60)), "PME edition", font=font(int(H * 0.045), bold=False), fill=(190, 235, 190, 255))
img.convert("RGB").save(out)
