$StepName = "Installing scoop buckets";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  scoop install fnm

  scoop bucket add extras
  scoop install posh-git
  scoop install git-aliases

  scoop bucket add nerd-fonts
  scoop install FiraCode
}

Write-Host -ForegroundColor Green "$StepName - Done";
