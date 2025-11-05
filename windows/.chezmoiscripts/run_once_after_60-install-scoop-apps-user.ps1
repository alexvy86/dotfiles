$StepName = "Installing scoop apps - user scope";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Note: some things are installed with scoop in in the general powershell setup script
# because they need to be installed with a different technology in Unix.

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  # From "main" bucket
  scoop install --no-update-scoop eza;
  scoop install --no-update-scoop deno;
  scoop install --no-update-scoop duf;
  scoop install --no-update-scoop ffmpeg;
  scoop install --no-update-scoop fnm;
  scoop install --no-update-scoop fzf;
  scoop install --no-update-scoop navi;
  # From "extras" bucket
  scoop install --no-update-scoop beyondcompare;
  # From "nerd-fonts" bucket
  scoop install --no-update-scoop CascadiaCode-NF;
  scoop install --no-update-scoop FiraCode-NF;
}

Write-Host -ForegroundColor Green "$StepName - Done";
