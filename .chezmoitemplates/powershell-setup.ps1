{{- if eq .chezmoi.os "windows" }}
Write-Host "Set execution policy for CurrentUser to RemoteSigned";
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser;
{{- end -}}

Write-Host "Trust PSGallery repository";
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;

# Install modules
Write-Host "Installing module git-aliases";
Install-Module git-aliases -Scope CurrentUser -AllowClobber;
Write-Host "Installing module posh-git";
Install-Module posh-git -Scope CurrentUser -Force;
Write-Host "Installing module Terminal-Icons";
Install-Module Terminal-Icons; # Note: Terminal-Icons requires a font from https://www.nerdfonts.com/
