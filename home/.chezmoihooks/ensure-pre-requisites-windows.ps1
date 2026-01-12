# This script must exit as fast as possible when pre-requisites are already
# met, so we only do the minimum necessary checks.

$ErrorActionPreference = "Stop"

$wantedPackages = @(
    "git"  # used to find the latest revisions of github repositories
)

$missingPackages = @()

foreach ($package in $wantedPackages) {
    if (-not (Get-Command $package -ErrorAction SilentlyContinue)) {
        $missingPackages += $package
    }
}

if ($missingPackages.Count -eq 0) {
    Write-Host "All pre-requisites for dotfiles handling by chezmoi are already installed."
    exit 0
}

Write-Host "Installing missing packages with winget: $($missingPackages -join ', ')"

# Map package names to winget package IDs
$wingetPackageIds = @{
    "git"  = "Git.Git"
}

foreach ($package in $missingPackages) {
    $packageId = $wingetPackageIds[$package]
    if ($packageId) {
        Write-Host "Installing $package..."
        winget install --id $packageId --accept-source-agreements --accept-package-agreements --silent
    } else {
        Write-Error "No winget package ID mapping for: $package"
    }
}
