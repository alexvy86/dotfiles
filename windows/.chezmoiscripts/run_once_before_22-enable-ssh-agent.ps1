$PowershellExecutable = "pwsh.exe"; # Use "powershell.exe" for Windows Powershell (<= 5.0). Might need to update the interpreters.ps1.command in .chezmoi.yaml.tmpl

# Self-elevate the script if required
# Taken from chezmoi's documentation: https://www.chezmoi.io/user-guide/machines/windows/
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments;
    Start-Process -Wait -FilePath $PowershellExecutable -Verb Runas -ArgumentList $CommandLine;
    Exit;
  }
}

$StepName = "Setting 'ssh-agent' Windows service to automatic startup.";
Write-Host -ForegroundColor Cyan $StepName;

Set-Service -Name "ssh-agent" -StartupType Automatic;
Start-Service -Name "ssh-agent";

Write-Host -ForegroundColor Green "$StepName - Done";
Write-Host "Press ENTER to continue";
Read-Host;
