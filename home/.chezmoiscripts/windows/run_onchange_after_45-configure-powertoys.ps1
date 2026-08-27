$ErrorActionPreference = "Stop";
$StepName = "Configuring PowerToys";
Write-Host -ForegroundColor Cyan $StepName;

$PowerToysInstallPath = Join-Path $env:LOCALAPPDATA "PowerToys";
$PowerToysSettingsExecutable = Join-Path $PowerToysInstallPath "WinUI3Apps\PowerToys.Settings.exe";
$PowerToysExecutable = Join-Path $PowerToysInstallPath "PowerToys.exe";

if (-not (Test-Path -LiteralPath $PowerToysSettingsExecutable -PathType Leaf)) {
  throw "PowerToys settings executable wasn't found at '$PowerToysSettingsExecutable'";
}

$PowerToysWasRunning = $null -ne (Get-Process -Name "PowerToys" -ErrorAction SilentlyContinue);

try {
  Get-Process -Name "PowerToys.Settings", "PowerToys" -ErrorAction SilentlyContinue |
    Stop-Process -Force -PassThru |
    Wait-Process;

  $SettingsToChange = @(
    @{ Name = "General.Enabled.AdvancedPaste"; DesiredValue = "True" },
    @{ Name = "General.Enabled.Awake"; DesiredValue = "False" },
    @{ Name = "General.Enabled.PowerLauncher"; DesiredValue = "True" }
  );

  foreach ($Setting in $SettingsToChange) {
    $Process = Start-Process -FilePath $PowerToysSettingsExecutable -ArgumentList @(
      "set",
      $Setting.Name,
      $Setting.DesiredValue
    ) -Wait -PassThru;

    if ($Process.ExitCode -ne 0) {
      throw "PowerToys failed to set '$($Setting.Name)' to '$($Setting.DesiredValue)' with exit code '$($Process.ExitCode)'";
    }
  }
} finally {
  if ($PowerToysWasRunning -and -not (Get-Process -Name "PowerToys" -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path -LiteralPath $PowerToysExecutable -PathType Leaf)) {
      throw "PowerToys executable wasn't found at '$PowerToysExecutable'";
    }

    Start-Process -FilePath $PowerToysExecutable;
  }
}

Write-Host -ForegroundColor Green "$StepName - Done";