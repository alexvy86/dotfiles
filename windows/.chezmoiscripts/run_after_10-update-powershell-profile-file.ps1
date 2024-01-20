# This script ensures that the Powershell profile file source-includes the file maintained in chezmoi,
# i.e. $HOME\.config\powershell\profile.ps1.

$newLine = [System.Environment]::NewLine;

$contents = @();
if (Test-Path $profile.CurrentUserAllHosts) {
	$contents = Get-Content $profile.CurrentUserAllHosts;
}

if (". `"`$HOME\.config\powershell\profile.ps1`";" -notin $contents) {
	$newContents = ". `"`$HOME\.config\powershell\profile.ps1`";$newline$newline$($contents -join $newline)";
	$newContents | Out-File -FilePath $profile.CurrentUserAllHosts;
	Write-Host "Updated '$($profile.CurrentUserAllHosts)' to include '`$HOME\.config\powershell\profile.ps1'";
} else {
	Write-Host "'$($profile.CurrentUserAllHosts)' already includes '`$HOME\.config\powershell\profile.ps1'";
}
