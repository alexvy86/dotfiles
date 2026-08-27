$ErrorActionPreference = "Stop";
$StepName = "Installing PowerToys";
Write-Host -ForegroundColor Cyan $StepName;

winget list --exact --id Microsoft.PowerToys --source winget --accept-source-agreements *> $null;
if ($LASTEXITCODE -eq 0) {
	Write-Host "PowerToys is already installed";
} else {
	winget install --exact --id Microsoft.PowerToys --source winget --accept-source-agreements --accept-package-agreements --silent;
	if ($LASTEXITCODE -ne 0) { throw "winget install failed with exit code '$LASTEXITCODE'" }
}

Write-Host -ForegroundColor Green "$StepName - Done";
