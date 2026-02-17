$StepName = "General PowerShell setup";
Write-Host -ForegroundColor Cyan $StepName;

Write-Host "Trust PSGallery repository";
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;

{{ if .is_windows -}}

Write-Host "Set execution policy for CurrentUser to RemoteSigned";
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser;
# Also do it for Windows PowerShell; useful as long as Nu shell uses powershell.exe instead of pwsh.exe to run ps1 scripts.
powershell.exe -c 'Set-ExecutionPolicy RemoteSigned -Scope CurrentUser'

# Install modules.
# On Windows, use scoop so they are installed to a folder outside My Documents which is in OneDrive.
# This means the script must run after scoop is installed, and since that probably happened because chezmoi installed
# it, we need to update the path first.

function Update-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
              ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Update-Path;

Write-Host "Installing module git-aliases";
scoop install git-aliases;
Write-Host "Installing module posh-git";
scoop install posh-git;

{{ else }}

# Install modules.
Write-Host "Installing module git-aliases";
Install-Module git-aliases -Scope CurrentUser -AllowClobber;
Write-Host "Installing module posh-git";
Install-Module posh-git -Scope CurrentUser -Force;

{{ end -}}

Write-Host -ForegroundColor Green "$StepName - Done";
