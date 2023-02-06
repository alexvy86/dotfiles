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
  scoop install --no-update-scoop fnm

  # From "extras" bucket
  scoop install --no-update-scoop posh-git
  scoop install --no-update-scoop git-aliases
  scoop install --no-update-scoop terminal-icons # Note: Terminal-Icons requires a font from https://www.nerdfonts.com/
}

Write-Host -ForegroundColor Green "$StepName - Done";
