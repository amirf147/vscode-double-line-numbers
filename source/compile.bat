@echo off
echo Compiling TypeScript files...

:: Create dist directory if it doesn't exist
if not exist dist mkdir dist

:: Compile TypeScript files
call tsc --outDir dist src/extension.ts src/lineHighlighter.ts

echo Compilation complete!
