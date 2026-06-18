# Post-apply verification for Windows targets.
#
# Asserts that `chezmoi apply` produced the files we expect, rather than just
# checking that the command exited 0. This exercises three things the CI smoke
# test otherwise can't see: template rendering, external downloads, and the
# platform isolation logic in .chezmoiignore.
#
# Run from the repo root: pwsh ./tests/verify-windows.ps1
# We collect every failure instead of stopping at the first so one miss doesn't hide the rest.
$ErrorActionPreference = 'Stop'
$script:Failures = 0

function Assert-Exists {
  param([string]$Path, [string]$Description)
  if (Test-Path -LiteralPath $Path) {
    Write-Host "  ok   $Description" -ForegroundColor Green
  } else {
    Write-Host "  FAIL $Description -- missing: $Path" -ForegroundColor Red
    $script:Failures++
  }
}

function Assert-Absent {
  param([string]$Path, [string]$Description)
  if (-not (Test-Path -LiteralPath $Path)) {
    Write-Host "  ok   $Description" -ForegroundColor Green
  } else {
    Write-Host "  FAIL $Description -- should not exist: $Path" -ForegroundColor Red
    $script:Failures++
  }
}

function Assert-Contains {
  param([string]$Path, [string]$Pattern, [string]$Description)
  if ((Test-Path -LiteralPath $Path) -and (Select-String -LiteralPath $Path -Pattern $Pattern -Quiet)) {
    Write-Host "  ok   $Description" -ForegroundColor Green
  } else {
    Write-Host "  FAIL $Description -- pattern '$Pattern' not found in: $Path" -ForegroundColor Red
    $script:Failures++
  }
}

$h = $env:USERPROFILE

Write-Host "Managed dotfiles:"
Assert-Exists   "$h\.gitconfig"                       ".gitconfig applied"
Assert-Contains "$h\.gitconfig" "716334\+alexvy86"    ".gitconfig rendered from template"
Assert-Exists   "$h\.gitconfig-maintenance"           ".gitconfig-maintenance created"
Assert-Exists   "$h\.bashrc"                          ".bashrc applied (kept on Windows for GitBash)"
Assert-Exists   "$h\.config\git\ignore"               "global gitignore applied"
Assert-Exists   "$h\.claude\CLAUDE.md"                "Claude config applied"
Assert-Exists   "$h\.config\powershell\profile.ps1"   "PowerShell profile applied"

Write-Host "Windows-specific files:"
Assert-Exists "$h\AppData\Roaming\navi\config.yaml"      "navi config applied"
Assert-Exists "$h\AppData\Roaming\navi\cheats\git.cheat" "navi git cheat downloaded"
Assert-Exists "$h\AppData\Roaming\nushell\config.nu"     "nushell config applied"
Assert-Exists "$h\AppData\Roaming\nushell\nu_scripts"    "nu_scripts cloned"
Assert-Exists "$h\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "Windows Terminal settings applied"
Assert-Exists "$h\.config\powertoys.dsc.yaml"            "PowerToys config applied"

Write-Host "Cross-platform isolation (Unix-only files absent):"
Assert-Absent "$h\.zshrc"               ".zshrc not applied on Windows"
Assert-Absent "$h\.oh-my-zsh"           "oh-my-zsh not applied on Windows"
Assert-Absent "$h\.local\bin\ssh-ident" "ssh-ident not applied on Windows"

Write-Host ""
if ($script:Failures -gt 0) {
  Write-Host "$($script:Failures) assertion(s) failed." -ForegroundColor Red
  exit 1
}
Write-Host "All assertions passed." -ForegroundColor Green
