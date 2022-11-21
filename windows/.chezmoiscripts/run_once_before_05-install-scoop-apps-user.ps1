$StepName = "Installing scoop apps - user scope";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  # From "main" bucket
  scoop install fnm

  # From "extras" bucket
  scoop install posh-git
  scoop install git-aliases
}

Write-Host -ForegroundColor Green "$StepName - Done";
