Write-Host "Set execution policy for CurrentUser to RemoteSigned";
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser;

Write-Host "Trust PSGallery repository";
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;
