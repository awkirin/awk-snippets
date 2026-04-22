@echo off
chcp 1251 >nul

set "BIN_DIR=%USERPROFILE%\bin"
set "SOURCE_DIR=%~dp0"
set "SOURCE_FILE=%SOURCE_DIR%\awkirin"
set "TARGET_FILE=%BIN_DIR%\awkirin.bat"

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

if exist "%TARGET_FILE%" del "%TARGET_FILE%"

(
echo @echo off
echo php "%SOURCE_FILE%" %%*
) > "%TARGET_FILE%"
