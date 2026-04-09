$htmlFile = Join-Path $PSScriptRoot "Andrew Goetz - Cover Letter.html"
$pdfFile  = Join-Path $PSScriptRoot "Andrew Goetz - Cover Letter.pdf"

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

# Remove stale PDF so we can detect when the new one appears
if (Test-Path $pdfFile) { Remove-Item $pdfFile }

$process = Start-Process -FilePath $edgePath `
    -ArgumentList "--headless","--disable-gpu","--no-pdf-header-footer","--print-to-pdf=`"$pdfFile`"",$uri `
    -PassThru -WindowStyle Hidden

$process.WaitForExit(30000) | Out-Null

# Wait briefly for file to flush to disk
$waited = 0
while (-not (Test-Path $pdfFile) -and $waited -lt 10) {
    Start-Sleep -Milliseconds 500
    $waited++
}

if (Test-Path $pdfFile) {
    Write-Host "PDF saved to '$pdfFile'"
} else {
    Write-Error "PDF generation failed."
    exit 1
}
