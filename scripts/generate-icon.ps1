# Generates the 1024x1024 iOS app icon for Woodlands Fishing using
# native Windows GDI+ via System.Drawing. No external dependencies.
# Re-run after editing if you want to tweak colors / proportions.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$size = 1024
$outPath = Join-Path (Split-Path $PSScriptRoot -Parent) "AppIcon-1024.png"

$bmp = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

# --- Background: vertical teal gradient ----------------------------------
$topColor = [System.Drawing.Color]::FromArgb(255, 8, 78, 86)
$botColor = [System.Drawing.Color]::FromArgb(255, 46, 168, 178)
$rect = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
$grad = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rect, $topColor, $botColor,
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$g.FillRectangle($grad, $rect)
$grad.Dispose()

# --- Soft upper-right highlight (implied light) --------------------------
$glowPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$glowPath.AddEllipse(
    [float]($size * 0.15),
    [float](-$size * 0.35),
    [float]($size * 1.10),
    [float]($size * 1.10)
)
$glow = [System.Drawing.Drawing2D.PathGradientBrush]::new($glowPath)
$glow.CenterColor = [System.Drawing.Color]::FromArgb(55, 255, 255, 255)
$glow.SurroundColors = ,([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
$g.FillPath($glow, $glowPath)
$glow.Dispose()
$glowPath.Dispose()

# --- Map pin teardrop behind the fish (drawn first, so fish overlays it) -
# Geometry: large circle centered slightly above mid-canvas with a triangular
# tip extending down. Tangent points to the tip computed exactly so the
# triangle's top edges meet the circle tangentially — clean teardrop union.
$pinCx = 512.0
$pinCy = 470.0
$pinR  = 400.0
$tipY  = 920.0

$dCP = $tipY - $pinCy
$alpha = [Math]::Acos($pinR / $dCP)
$tx = $pinR * [Math]::Sin($alpha)
$ty = $pinR * [Math]::Cos($alpha)

function P {
    param($x, $y)
    return [System.Drawing.PointF]::new([float]$x, [float]$y)
}

$pinCircle = [System.Drawing.Drawing2D.GraphicsPath]::new()
$pinCircle.AddEllipse(
    [float]($pinCx - $pinR),
    [float]($pinCy - $pinR),
    [float]($pinR * 2),
    [float]($pinR * 2)
)

$pinTri = [System.Drawing.Drawing2D.GraphicsPath]::new()
$pinTri.AddPolygon(@(
    (P ($pinCx - $tx) ($pinCy + $ty)),
    (P ($pinCx + $tx) ($pinCy + $ty)),
    (P $pinCx $tipY)
))

$pinRegion = [System.Drawing.Region]::new($pinCircle)
$pinRegion.Union($pinTri)

# Slightly darker teal at low opacity — subtle "shadow pin" behind the fish
$pinBrush = [System.Drawing.SolidBrush]::new(
    [System.Drawing.Color]::FromArgb(95, 4, 48, 54)
)
$g.FillRegion($pinBrush, $pinRegion)
$pinBrush.Dispose()
$pinRegion.Dispose()
$pinCircle.Dispose()
$pinTri.Dispose()

# --- Fish silhouette -----------------------------------------------------
# Bass-inspired profile with integrated dorsal hump (no awkward stuck-on fin).
# All curves are part of one continuous path; the silhouette IS the gesture.
$cx = 512.0
$cy = 500.0
$bw = 640.0
$bh = 280.0

$fish = [System.Drawing.Drawing2D.GraphicsPath]::new()

# Anchor points going clockwise from the nose
$nose       = P ($cx + $bw * 0.50)  $cy
$dorsalPeak = P ($cx - $bw * 0.05) ($cy - $bh * 0.62)
$tailTop    = P ($cx - $bw * 0.45) ($cy - $bh * 0.32)
$tailNotch  = P ($cx - $bw * 0.36)  $cy
$tailBot    = P ($cx - $bw * 0.45) ($cy + $bh * 0.32)
$bellyLow   = P ($cx + $bw * 0.05) ($cy + $bh * 0.58)

# Top: nose -> dorsal peak (front half of back rises gently)
$c1 = P ($cx + $bw * 0.38) ($cy - $bh * 0.28)
$c2 = P ($cx + $bw * 0.18) ($cy - $bh * 0.60)
$fish.AddBezier($nose, $c1, $c2, $dorsalPeak)

# Top: dorsal peak -> tail top (descends into tail)
$c3 = P ($cx - $bw * 0.22) ($cy - $bh * 0.60)
$c4 = P ($cx - $bw * 0.36) ($cy - $bh * 0.48)
$fish.AddBezier($dorsalPeak, $c3, $c4, $tailTop)

# Tail fork (shallow, elegant)
$fish.AddLine($tailTop, $tailNotch)
$fish.AddLine($tailNotch, $tailBot)

# Bottom: tail bot -> belly low (deeper belly toward front)
$c5 = P ($cx - $bw * 0.36) ($cy + $bh * 0.48)
$c6 = P ($cx - $bw * 0.20) ($cy + $bh * 0.62)
$fish.AddBezier($tailBot, $c5, $c6, $bellyLow)

# Bottom: belly low -> nose (chin sweep up to head)
$c7 = P ($cx + $bw * 0.30) ($cy + $bh * 0.42)
$c8 = P ($cx + $bw * 0.44) ($cy + $bh * 0.10)
$fish.AddBezier($bellyLow, $c7, $c8, $nose)

$fish.CloseFigure()

$cream = [System.Drawing.Color]::FromArgb(255, 246, 233, 200)
$fishBrush = [System.Drawing.SolidBrush]::new($cream)
$g.FillPath($fishBrush, $fish)
$fishBrush.Dispose()

# --- Pectoral fin (subtle, slightly darker, integrated under the body) ---
$pectoral = [System.Drawing.Drawing2D.GraphicsPath]::new()
$pf1 = P ($cx + $bw * 0.10) ($cy + $bh * 0.18)
$pf2 = P ($cx - $bw * 0.04) ($cy + $bh * 0.50)
$pfc1 = P ($cx + $bw * 0.14) ($cy + $bh * 0.40)
$pfc2 = P ($cx + $bw * 0.04) ($cy + $bh * 0.52)
$pectoral.AddBezier($pf1, $pfc1, $pfc2, $pf2)
$pfc3 = P ($cx - $bw * 0.02) ($cy + $bh * 0.40)
$pfc4 = P ($cx + $bw * 0.06) ($cy + $bh * 0.28)
$pectoral.AddBezier($pf2, $pfc3, $pfc4, $pf1)
$pectoral.CloseFigure()
$finBrush = [System.Drawing.SolidBrush]::new(
    [System.Drawing.Color]::FromArgb(255, 222, 207, 168)
)
$g.FillPath($finBrush, $pectoral)
$finBrush.Dispose()
$pectoral.Dispose()

# --- Eye -----------------------------------------------------------------
$eyeR = 17.0
$eyeX = $cx + $bw * 0.32
$eyeY = $cy - $bh * 0.18
$eyeBrush = [System.Drawing.SolidBrush]::new(
    [System.Drawing.Color]::FromArgb(255, 12, 50, 56)
)
$g.FillEllipse(
    $eyeBrush,
    [float]($eyeX - $eyeR),
    [float]($eyeY - $eyeR),
    [float]($eyeR * 2),
    [float]($eyeR * 2)
)
$eyeBrush.Dispose()

# Tiny catch-light highlight on the eye (top-right)
$catch = [System.Drawing.SolidBrush]::new(
    [System.Drawing.Color]::FromArgb(180, 246, 233, 200)
)
$g.FillEllipse(
    $catch,
    [float]($eyeX - $eyeR * 0.2),
    [float]($eyeY - $eyeR * 0.55),
    [float]($eyeR * 0.55),
    [float]($eyeR * 0.55)
)
$catch.Dispose()

# --- Save ----------------------------------------------------------------
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Output "Saved: $outPath"
