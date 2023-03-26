Write-Host "Set execution policy for CurrentUser to RemoteSigned";
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser;

Write-Host "Trust PSGallery repository";
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;

# Install modules
Install-Module git-aliases -Scope CurrentUser -AllowClobber;
Install-Module posh-git -Scope CurrentUser -Force;
Install-Module Terminal-Icons; # Note: Terminal-Icons requires a font from https://www.nerdfonts.com/
