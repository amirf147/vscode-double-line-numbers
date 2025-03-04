# PowerShell script to capture a screenshot of the demo HTML page

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define the path to the HTML file and output PNG
$htmlPath = "$PSScriptRoot\line-highlight-demo.html"
$pngPath = "$PSScriptRoot\line-highlight-demo.png"

# First, open the HTML file in the default browser
Start-Process $htmlPath

# Wait for the browser to load
Start-Sleep -Seconds 3

# Take a screenshot
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)

# Save the screenshot
$bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Clean up resources
$graphics.Dispose()
$bitmap.Dispose()

Write-Host "Screenshot saved to: $pngPath"

# Close all browser windows (optional)
# Get-Process -Name msedge, chrome, firefox | Where-Object { $_.MainWindowTitle -ne "" } | Stop-Process
