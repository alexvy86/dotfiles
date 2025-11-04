$StepName = "General PowerShell setup";
Write-Host -ForegroundColor Cyan $StepName;

Write-Host "Trust PSGallery repository";
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;

{{ if .is_windows -}}

Write-Host "Set execution policy for CurrentUser to RemoteSigned";
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser;

# Install modules.
# On Windows, use scoop so they are installed to a folder outside My Documents which is in OneDrive.
# This means the script must run after scoop is installed.
Write-Host "Installing module git-aliases";
scoop install git-aliases;
Write-Host "Installing module posh-git";
scoop install posh-git;
Write-Host "Installing module Terminal-Icons";
scoop install terminal-icons; # Note: Terminal-Icons requires a font from https://www.nerdfonts.com/
Write-Host "Installing module DockerCompletion";
scoop install DockerCompletion;

{{ else }}

# Install modules.
Write-Host "Installing module git-aliases";
Install-Module git-aliases -Scope CurrentUser -AllowClobber;
Write-Host "Installing module posh-git";
Install-Module posh-git -Scope CurrentUser -Force;
Write-Host "Installing module Terminal-Icons";
Install-Module Terminal-Icons; # Note: Terminal-Icons requires a font from https://www.nerdfonts.com/
Write-Host "Installing module DockerCompletion";
Install-Module DockerCompletion;

{{ end -}}

Write-Host -ForegroundColor Green "$StepName - Done";
