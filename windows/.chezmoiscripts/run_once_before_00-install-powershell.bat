@ECHO OFF
WHERE winget >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 ECHO 'winget' was not found && EXIT /b 1

winget list --exact Microsoft.PowerShell --source winget >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
    ECHO Installing PowerShell
    winget install --exact Microsoft.PowerShell --source winget || EXIT /b 1
    ECHO PowerShell installed successfully
) else (
    ECHO PowerShell is already installed
)
