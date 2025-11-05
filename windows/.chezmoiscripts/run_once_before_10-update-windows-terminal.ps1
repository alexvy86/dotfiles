$StepName = "Updating Windows Terminal"
Write-Host -ForegroundColor Cyan $StepName;

# Update Windows Terminal so we're running the latest version and using the latest features
# during the rest of the setup.
winget update --exact Microsoft.WindowsTerminal --source winget;

Write-Host -ForegroundColor Green "$StepName - Done";
