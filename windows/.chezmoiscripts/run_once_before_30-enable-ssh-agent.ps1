$ErrorActionPreference = "Stop";
$StepName = "Setting 'ssh-agent' Windows service to automatic startup.";
Write-Host -ForegroundColor Cyan $StepName;

$service = Get-Service -Name "ssh-agent";

if (($service.StartupType -eq "Automatic") -and ($service.Status -eq "Running")) {
  Write-Host "ssh-agent service already running and configured for automatic startup.";
  Write-Host -ForegroundColor Green "$StepName - Done";
  exit 0;
}

$PowershellExecutable = "pwsh.exe"; # Use "powershell.exe" for Windows Powershell (<= 5.0). Might need to update the interpreters.ps1.command in .chezmoi.yaml.tmpl

# Self-elevate the script if required
# Taken from chezmoi's documentation: https://www.chezmoi.io/user-guide/machines/windows/
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments;
    $process = Start-Process -Wait -PassThru -FilePath $PowershellExecutable -Verb Runas -ArgumentList $CommandLine;
    if ($process.ExitCode -ne 0) {
      Write-Host -ForegroundColor Red "$StepName - Error running elevated script";
      Exit $process.ExitCode;
    }
    Write-Host -ForegroundColor Green "$StepName - Done";
    Exit;
  }
}

Set-Service -Name "ssh-agent" -StartupType Automatic;
Start-Service -Name "ssh-agent";

Write-Host -ForegroundColor Green "$StepName - Done";
Write-Host "Press ENTER to continue";
Read-Host;
