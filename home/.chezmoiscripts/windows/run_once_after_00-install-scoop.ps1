$StepName = "Installing scoop and adding buckets";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Install scoop if it's not installed yet
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
  $TmpPathToInstallScript = "$($env:TEMP)\install.ps1";
  # Use fixed version of the install script
  Invoke-RestMethod https://raw.githubusercontent.com/ScoopInstaller/Install/ff4eedda58d832b8225d7697510f097ebe8ab071/install.ps1 -OutFile $TmpPathToInstallScript;
  Invoke-Expression "& $TmpPathToInstallScript -ScoopDir '$env:WIN_TOOLS_PATH/scoop'";
  Remove-Item -Path $TmpPathToInstallScript;
}

Update-Path;

# Unfortunately, scoop installs itself as a ps1 script that won't cause an error to
# terminate the calling script even when $PSNativeCommandUseErrorActionPreference = $true
# plus $ErrorActionPreference = "Stop". So we need to check the exit code manually.
scoop bucket add extras;
if ($LASTEXITCODE -ne 0) { throw "Failed to install bucket 'extras'. Exit code: $LASTEXITCODE" }
scoop bucket add nerd-fonts;
if ($LASTEXITCODE -ne 0) { throw "Failed to install bucket 'nerd-fonts'. Exit code: $LASTEXITCODE" }
scoop update;
if ($LASTEXITCODE -ne 0) { throw "Failed to update scoop. Exit code: $LASTEXITCODE" }

Write-Host -ForegroundColor Green "$StepName - Done";
