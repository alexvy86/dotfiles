$StepName = "Installing scoop apps - global scope";
Write-Host -ForegroundColor Cyan $StepName;

# Error out if scoop is not installed
Get-Command "scoop" -ErrorAction Stop > $null;

$ScoopAppsToInstall = @();

# Fonts need to be installed system-wide. See https://github.com/matthewjberger/scoop-nerd-fonts/pull/200 for details.
# CascadiaCode-NF is the NerdFonts font we install for the Terminal-Icons module to display its icons.
$ScoopAppsToInstall += "FiraCode-NF";
$ScoopAppsToInstall += "CascadiaCode-NF";

$EverythingInstalled = $true;

foreach ($app in $ScoopAppsToInstall) {
  if ($null -eq (scoop info $app).Installed) {
    $EverythingInstalled = $false;
    break;
  }
}

if ($EverythingInstalled -eq $true) {
  Write-Host "All apps for global scope are already installed.";
  Write-Host -ForegroundColor Green "$StepName - Done";
  Exit;
}

$PowershellExecutable = "pwsh.exe"; # Use "powershell.exe" for Windows Powershell (<= 5.0). Might need to update the interpreters.ps1.command in .chezmoi.yaml.tmpl

# Self-elevate the script if required
# Taken from chezmoi's documentation: https://www.chezmoi.io/user-guide/machines/windows/
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments;
    Start-Process -Wait -FilePath $PowershellExecutable -Verb Runas -ArgumentList $CommandLine;
    Write-Host -ForegroundColor Green "$StepName - Done";
    Exit;
  }
}

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

foreach ($app in $ScoopAppsToInstall) {
  scoop install --no-update-scoop -g $app;
}

Write-Host -ForegroundColor Green "$StepName - Done";
Write-Host "Press ENTER to continue";
Read-Host;
