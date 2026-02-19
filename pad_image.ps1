param (
    [string]$inputPath,
    [string]$outputPath
)

Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Image]::FromFile($inputPath)
$limit = [Math]::Max($img.Width, $img.Height)
$size = [int][Math]::Round($limit * 1.6)

$bmp = New-Object System.Drawing.Bitmap($size, $size)
$graph = [System.Drawing.Graphics]::FromImage($bmp)
$graph.Clear([System.Drawing.Color]::White)

$x = ($size - $img.Width) / 2
$y = ($size - $img.Height) / 2

$graph.DrawImage($img, $x, $y, $img.Width, $img.Height)
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$img.Dispose()
$bmp.Dispose()
$graph.Dispose()

Write-Host "Image saved to $outputPath"
