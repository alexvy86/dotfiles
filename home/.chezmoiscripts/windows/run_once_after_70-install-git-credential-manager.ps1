$StepName = "Installing Git Credential Manager";
Write-Host -ForegroundColor Cyan $StepName;

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

# Check if git-credential-manager is already installed
$gcmInstalled = Get-Command "git-credential-manager" -ErrorAction SilentlyContinue

if ($gcmInstalled) {
  Write-Host "Git Credential Manager is already installed";
} else {
  Write-Host "Installing Git Credential Manager via winget...";
  
  # Install Git Credential Manager using winget
  winget install --exact --id Git.GCM --source winget --silent --accept-package-agreements --accept-source-agreements;
  
  # Update PATH to include the newly installed tool
  Update-Path;
  
  Write-Host "Git Credential Manager installed successfully";
}

# Configure Git Credential Manager
Write-Host "Configuring Git Credential Manager...";
git-credential-manager configure;

Write-Host -ForegroundColor Green "$StepName - Done";
