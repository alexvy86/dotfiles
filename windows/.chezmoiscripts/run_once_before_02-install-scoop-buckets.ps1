$StepName = "Installing scoop buckets";
Write-Host -ForegroundColor Cyan $StepName;

function refresh-path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

refresh-path;

# Error out if scoop is not installed
if (Get-Command "scoop" -ErrorAction Stop) {
  # Install desired scoop buckets
  #scoop config aria2-enabled false
  #scoop install git
  #scoop bucket add extras
  #scoop bucket add twpayne https://github.com/twpayne/scoop-bucket
  #scoop bucket add nerd-fonts
}

Write-Host -ForegroundColor Green "$StepName - Done";
