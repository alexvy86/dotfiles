$settingsToChange = @();

# Disable browser tabs showing up in Alt-Tab. Works in Windows 10 and 11.
$settingsToChange += @{
	Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name = "MultiTaskingAltTabFilter";
	DesiredValue = 3;
};

# Apply registry changes
Write-Host "Updating registry settings";

$settingsToChange | ForEach-Object {
	$currentValue = Get-ItemPropertyValue -Path $_.Path -Name $_.Name;
	Write-Host "$($_.Path)/$($_.Name) - Current value: $currentValue - New value: $($_.DesiredValue)";
	Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.DesiredValue;
}
