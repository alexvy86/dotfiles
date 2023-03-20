@ECHO OFF
winget list --exact Microsoft.PowerShell >NUL  2>NUL
if %ERRORLEVEL% NEQ 0 (
    ECHO Installing PowerShell
    winget install Microsoft.PowerShell
    ECHO PowerShell installed successfully
) else (
    ECHO PowerShell is already installed
)
