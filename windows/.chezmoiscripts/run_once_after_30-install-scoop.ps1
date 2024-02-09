$StepName = "Installing scoop"
Write-Host -ForegroundColor Cyan $StepName;

# Install scoop if it's not installed yet
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
  $TmpPathToInstallScript = "$($env:TEMP)\install.ps1";
  # Use fixed version of the install script
  Invoke-RestMethod https://raw.githubusercontent.com/ScoopInstaller/Install/d389cb126d1f4c9487ed4f84330961f700765fe2/install.ps1 -OutFile $TmpPathToInstallScript;
  Invoke-Expression "& $TmpPathToInstallScript -ScoopDir '$env:WIN_TOOLS_PATH/scoop'";
  Remove-Item -Path $TmpPathToInstallScript;
}

Write-Host -ForegroundColor Green "$StepName - Done";
