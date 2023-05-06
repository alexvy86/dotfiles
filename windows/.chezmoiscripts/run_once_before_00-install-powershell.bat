@ECHO OFF
winget list --exact Microsoft.PowerShell --source winget >NUL  2>NUL
if %ERRORLEVEL% NEQ 0 (
    ECHO Installing PowerShell
    winget install --exact Microsoft.PowerShell --source winget
    ECHO PowerShell installed successfully
) else (
    ECHO PowerShell is already installed
)
