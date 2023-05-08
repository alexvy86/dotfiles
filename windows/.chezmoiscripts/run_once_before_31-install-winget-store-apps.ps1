# TODO: figure out why this didn't work (in Windows 11)
# DevToys and WhatsApp always complained of "Verifying/Requesting package acquisition failed: server error"

# $StepName = "Installing regular applications with winget";
# Write-Host -ForegroundColor Cyan $StepName;

# $Packages = @(
# 	@{Id="9NBLGGH4NNS1"; Name="App Installer"},
# 	@{Id="9PGCV4V3BK4W"; Name="Dev Toys"},
# 	@{Id="9NKSQGP7F2NH"; Name="WhatsApp"}
# 	);

# $Packages | ForEach-Object {
# 	winget list --exact --id $_.Id --source msstore > $null;
# 	if ($LastExitCode -eq 0) {
# 		Write-Host "Package $($_.Name) ($($_.Id)) is already installed";
# 	} else {
# 		Write-Host "Installing MSStore app $($_.Name) ($($_.Id))";
# 		winget install --exact --id $_.Id --source msstore --accept-package-agreements --accept-source-agreements;
# 	}
# }

# Write-Host -ForegroundColor Green "$StepName - Done";
