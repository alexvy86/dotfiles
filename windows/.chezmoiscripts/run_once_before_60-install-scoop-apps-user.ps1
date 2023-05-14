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
  scoop install --no-update-scoop fnm;
  scoop install --no-update-scoop deno;
  scoop install --no-update-scoop navi;
}

Write-Host -ForegroundColor Green "$StepName - Done";
