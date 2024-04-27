$StepName = "Installing and configuring PowerToys";
Write-Host -ForegroundColor Cyan $StepName;

winget configure --accept-configuration-agreements --file "$env:USERPROFILE/.config/powertoys.dsc.yaml";

Write-Host -ForegroundColor Green "$StepName - Done";
