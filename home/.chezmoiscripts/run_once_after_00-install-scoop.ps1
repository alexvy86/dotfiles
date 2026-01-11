$StepName = "Installing scoop"
Write-Host -ForegroundColor Cyan $StepName;

# Install scoop if it's not installed yet
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
  $TmpPathToInstallScript = "$($env:TEMP)\install.ps1";
  # Use fixed version of the install script
  Invoke-RestMethod https://raw.githubusercontent.com/ScoopInstaller/Install/ff4eedda58d832b8225d7697510f097ebe8ab071/install.ps1 -OutFile $TmpPathToInstallScript;
  Invoke-Expression "& $TmpPathToInstallScript -ScoopDir '$env:WIN_TOOLS_PATH/scoop'";
  Remove-Item -Path $TmpPathToInstallScript;
}

Write-Host -ForegroundColor Green "$StepName - Done";
