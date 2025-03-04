@echo off
echo ===================================================
echo VS Code Extension Setup and Compilation Helper
echo ===================================================
echo.

echo Checking for Node.js installation...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Node.js is not installed or not in PATH.
    echo.
    echo Please download and install Node.js from:
    echo https://nodejs.org/en/download/ (LTS version recommended)
    echo.
    echo After installing Node.js, run this batch file again.
    echo.
    echo Would you like to open the Node.js download page?
    set /p OPEN_BROWSER=Type 'yes' to open browser or any key to exit: 
    if /i "%OPEN_BROWSER%"=="yes" start https://nodejs.org/en/download/
    pause
    exit /b 1
)

echo Node.js is installed. Version:
node --version
echo.

echo Checking for npm installation...
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo npm is not installed or not in PATH.
    echo This is unusual as npm typically comes with Node.js.
    echo Please reinstall Node.js and ensure npm is included.
    pause
    exit /b 1
)

echo npm is installed. Version:
npm --version
echo.

echo ===================================================
echo Installing dependencies and compiling extension...
echo ===================================================
echo.

echo Running npm install to get dependencies...
npm install
if %ERRORLEVEL% NEQ 0 (
    echo Error during npm install.
    pause
    exit /b 1
)

echo.
echo Running npm run compile to build the extension...
npm run compile
if %ERRORLEVEL% NEQ 0 (
    echo Error during compilation.
    pause
    exit /b 1
)

echo.
echo ===================================================
echo Compilation completed successfully!
echo ===================================================
echo.
echo To test the extension in VS Code:
echo 1. Press F5 in VS Code to start debugging
echo 2. This will open a new VS Code window with the extension loaded
echo 3. Open a file and test the line highlighting feature
echo.
echo Would you like to open VS Code now?
set /p OPEN_VSCODE=Type 'yes' to open VS Code or any key to exit: 
if /i "%OPEN_VSCODE%"=="yes" start code .

echo.
pause
