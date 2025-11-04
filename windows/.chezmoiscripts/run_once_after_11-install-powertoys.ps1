$ErrorActionPreference = "Stop";
$StepName = "Installing and configuring PowerToys";
Write-Host -ForegroundColor Cyan $StepName;

winget configure --enable;
winget configure --accept-configuration-agreements --file "$env:USERPROFILE/.config/powertoys.dsc.yaml";

if ($LASTEXITCODE -ne 0) { throw "Failed to apply Winget configuration. Exit code: $LASTEXITCODE" }

Write-Host -ForegroundColor Green "$StepName - Done";
