@echo off
echo ===================================================
echo Adding Node.js to PATH
echo ===================================================
echo.

echo Checking for Node.js installation location...

:: Try to find Node.js installation paths
set NODE_PATHS=C:\Program Files\nodejs;C:\Program Files (x86)\nodejs;%APPDATA%\npm;%USERPROFILE%\AppData\Roaming\npm

echo Possible Node.js locations to check:
echo %NODE_PATHS%
echo.

set FOUND_NODE=0

for %%i in (%NODE_PATHS%) do (
    if exist "%%i\node.exe" (
        echo Found Node.js at: %%i
        set NODE_PATH=%%i
        set FOUND_NODE=1
    )
)

if %FOUND_NODE% EQU 0 (
    echo Could not automatically find Node.js installation.
    echo.
    echo Please enter the full path to your Node.js installation folder
    echo (e.g., C:\Program Files\nodejs):
    set /p NODE_PATH=Path: 
    
    if not exist "%NODE_PATH%\node.exe" (
        echo.
        echo Error: node.exe not found in the specified directory.
        echo Please make sure you entered the correct path.
        pause
        exit /b 1
    )
)

echo.
echo Adding Node.js to PATH for this session...
set PATH=%NODE_PATH%;%PATH%

echo.
echo Testing Node.js...
node --version

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: Failed to run Node.js.
    pause
    exit /b 1
)

echo.
echo Node.js is now available in this terminal session.

echo.
echo Would you like to add Node.js to your system PATH permanently?
echo This will make Node.js available in all future terminal sessions.
echo (This requires administrator privileges)
set /p ADD_PERMANENT=Type 'yes' to add permanently or any key to skip: 

if /i "%ADD_PERMANENT%"=="yes" (
    echo.
    echo Adding Node.js to system PATH permanently...
    
    :: Create a temporary script to modify PATH
    echo Set oWS = WScript.CreateObject("WScript.Shell") > %TEMP%\addtopath.vbs
    echo sPath = oWS.ExpandEnvironmentStrings("%%PATH%%") >> %TEMP%\addtopath.vbs
    echo If InStr(1, sPath, "%NODE_PATH%;", vbTextCompare) = 0 Then >> %TEMP%\addtopath.vbs
    echo    sPath = "%NODE_PATH%;" ^& sPath >> %TEMP%\addtopath.vbs
    echo    oWS.Environment("SYSTEM").Item("PATH") = sPath >> %TEMP%\addtopath.vbs
    echo End If >> %TEMP%\addtopath.vbs
    
    :: Run the script with admin privileges
    echo Requesting administrator privileges to modify PATH...
    powershell -Command "Start-Process cscript -ArgumentList '"%TEMP%\addtopath.vbs"' -Verb RunAs"
    
    echo.
    echo Node.js has been added to your system PATH.
    echo You may need to restart your computer for the changes to take effect.
)

echo.
echo ===================================================
echo Ready to compile the extension
echo ===================================================
echo.

echo Would you like to compile the extension now?
set /p COMPILE_NOW=Type 'yes' to compile or any key to exit: 

if /i "%COMPILE_NOW%"=="yes" (
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
    echo Compilation completed successfully!
    echo.
    echo To test the extension in VS Code:
    echo 1. Press F5 in VS Code to start debugging
    echo 2. This will open a new VS Code window with the extension loaded
    echo 3. Open a file and test the line highlighting feature
)

echo.
pause
