$htmlFile = Join-Path $PSScriptRoot "Andrew Goetz - Resume.html"
$pdfFile  = Join-Path $PSScriptRoot "Andrew Goetz - Resume.pdf"

# Use Microsoft Edge (Chromium) in headless mode to print to PDF
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
    $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}

if (-not (Test-Path $edgePath)) {
    Write-Error "Microsoft Edge not found. Install Edge or update the path in this script."
    exit 1
}

$uri = ([Uri](Resolve-Path $htmlFile).Path).AbsoluteUri

Write-Host "Converting '$htmlFile' to PDF..."
& $edgePath --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="$pdfFile" $uri 2>$null

if (Test-Path $pdfFile) {
    Write-Host "PDF saved to '$pdfFile'"
} else {
    Write-Error "PDF generation failed."
    exit 1
}
