$StepName = "Adding scoop buckets";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  scoop bucket --no-update-scoop add extras
  scoop bucket --no-update-scoop add nerd-fonts
}

Write-Host -ForegroundColor Green "$StepName - Done";
