# Install scoop if it's not installed yet
if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
  # Use fixed version of the install script
  Invoke-RestMethod https://raw.githubusercontent.com/ScoopInstaller/Install/d389cb126d1f4c9487ed4f84330961f700765fe2/install.ps1 | Invoke-Expression;
}

# Install desired scoop buckets
#scoop config aria2-enabled false
#scoop install git
#scoop bucket add extras
#scoop bucket add twpayne https://github.com/twpayne/scoop-bucket
#scoop bucket add nerd-fonts

