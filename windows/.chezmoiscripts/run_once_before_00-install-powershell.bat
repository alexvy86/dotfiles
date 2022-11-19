winget list --exact Microsoft.PowerShell
if  %ERRORLEVEL% NEQ 0 (
    winget install Microsoft.PowerShell
)
