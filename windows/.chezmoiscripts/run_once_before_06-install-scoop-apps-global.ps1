$PowershellExecutable = "pwsh.exe"; # Use "powershell.exe" for Windows Powershell (<= 5.0). Might need to update the interpreters.ps1.command in .chezmoi.yaml.tmpl

# Self-elevate the script if required
# Taken from chezmoi's documentation: https://www.chezmoi.io/user-guide/machines/windows/
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments;
    Start-Process -FilePath $PowershellExecutable -Verb Runas -ArgumentList $CommandLine;
    Exit
  }
}

$StepName = "Installing scoop apps - global scope";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  # Fonts need to be installed system-wide. See https://github.com/matthewjberger/scoop-nerd-fonts/pull/200 for details.
  scoop install -g FiraCode
}

Write-Host -ForegroundColor Green "$StepName - Done";
