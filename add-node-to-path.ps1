# PowerShell script to add Node.js to PATH

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Adding Node.js to PATH" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Ask user for Node.js installation path
Write-Host "Please enter the full path to your Node.js installation folder" -ForegroundColor Yellow
Write-Host "(e.g., C:\Program Files\nodejs):" -ForegroundColor Yellow
$nodePath = Read-Host "Path"

# Check if the path exists and contains node.exe
if (-not (Test-Path "$nodePath\node.exe")) {
    Write-Host ""
    Write-Host "Error: node.exe not found in the specified directory." -ForegroundColor Red
    Write-Host "Please make sure you entered the correct path." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Add to PATH for current session
Write-Host ""
Write-Host "Adding Node.js to PATH for this session..." -ForegroundColor Green
$env:Path = "$nodePath;$env:Path"

# Test Node.js
Write-Host ""
Write-Host "Testing Node.js..." -ForegroundColor Green
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to run Node.js." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Node.js is now available in this terminal session." -ForegroundColor Green

# Ask if user wants to add to PATH permanently
Write-Host ""
Write-Host "Would you like to add Node.js to your system PATH permanently?" -ForegroundColor Yellow
Write-Host "This will make Node.js available in all future terminal sessions." -ForegroundColor Yellow
Write-Host "(This requires administrator privileges)" -ForegroundColor Yellow
$addPermanent = Read-Host "Type 'yes' to add permanently or any key to skip"

if ($addPermanent -eq "yes") {
    Write-Host ""
    Write-Host "Adding Node.js to system PATH permanently..." -ForegroundColor Green
    
    # Create a script that will modify the PATH
    $tempScript = @"
    `$nodePath = '$nodePath'
    `$currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (-not `$currentPath.Contains(`$nodePath)) {
        `$newPath = `$nodePath + ';' + `$currentPath
        [Environment]::SetEnvironmentVariable('Path', `$newPath, 'User')
        Write-Host "Node.js has been added to your user PATH." -ForegroundColor Green
    } else {
        Write-Host "Node.js is already in your PATH." -ForegroundColor Yellow
    }
"@
    
    $tempScriptPath = "$env:TEMP\add-node-to-path-temp.ps1"
    $tempScript | Out-File -FilePath $tempScriptPath -Encoding UTF8
    
    # Run the script with elevated privileges
    Write-Host "Requesting administrator privileges to modify PATH..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$tempScriptPath`"" -Verb RunAs -Wait
    
    # Clean up
    Remove-Item $tempScriptPath -Force
    
    Write-Host ""
    Write-Host "You may need to restart your computer for the changes to take effect." -ForegroundColor Yellow
}

# Compile the extension
Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Ready to compile the extension" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Would you like to compile the extension now?" -ForegroundColor Yellow
$compileNow = Read-Host "Type 'yes' to compile or any key to exit"

if ($compileNow -eq "yes") {
    # Navigate to the extension directory
    Set-Location -Path "$PSScriptRoot"
    
    Write-Host ""
    Write-Host "Running npm install to get dependencies..." -ForegroundColor Green
    npm install
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error during npm install." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "Running npm run compile to build the extension..." -ForegroundColor Green
    npm run compile
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error during compilation." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "Compilation completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To test the extension in VS Code:" -ForegroundColor Yellow
    Write-Host "1. Press F5 in VS Code to start debugging" -ForegroundColor Yellow
    Write-Host "2. This will open a new VS Code window with the extension loaded" -ForegroundColor Yellow
    Write-Host "3. Open a file and test the line highlighting feature" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
