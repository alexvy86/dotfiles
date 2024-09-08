$StepName = "Updating registry settings";
Write-Host -ForegroundColor Cyan $StepName;

$settingsToChange = @();

# Disable browser tabs showing up in Alt-Tab. Applies to Windows 10 and 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "MultiTaskingAltTabFilter";
	DesiredValue = 3;
};

# Hide the "Widgets" button in the taskbar. Applies to Windows 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "TaskbarDa";
	DesiredValue = 0;
};

# Hide the "TaskView" button in the taskbar. Applies to Windows 10 and 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "ShowTaskViewButton";
	DesiredValue = 0;
};

# Hide the "Chat" button in the taskbar. Applies to Windows 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "TaskbarMn";
	DesiredValue = 0;
};

# Left-align the Start Menu. Applies to Windows 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "TaskbarAl";
	DesiredValue = 0;
};

# Show hidden files in Windows Explorer. Applies to Windows 10 and 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "Hidden";
	DesiredValue = 1;
};

# Show file extensions in Windows Explorer. Applies to Windows 10 and 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "HideFileExt";
	DesiredValue = 0;
};

# Disable new context menu in Windows 11.
# Not a fan, plus it might be related to crashes of explorer.exe I've experienced in my personal computer.
$settingsToChange += @{
	Path         = "HKCU:\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}\InprocServer32";
	Name         = "(default)";
	DesiredValue = "";
};

# Apply registry changes
$settingsToChange | ForEach-Object {
	$pathExists = Test-Path -Path $_.Path;
	if ($True -eq $pathExists) {
		$propertyExists = (Get-ItemProperty -Path $_.Path -Name $_.Name -ErrorAction SilentlyContinue) -ne $null;
		if ($True -eq $propertyExists) {
			$currentValue = Get-ItemPropertyValue -Path $_.Path -Name $_.Name;
			if ($currentValue -eq $_.DesiredValue) {
				Write-Host "$($_.Path) -> $($_.Name) already has the desired value '$($_.DesiredValue)'";
				return;
			}
			Write-Host "$($_.Path) -> $($_.Name) - Current value: '$currentValue' - New value: '$($_.DesiredValue)'";
		}
	} else {
		Write-Host "Creating new registry entry at $($_.Path) -> $($_.Name) with value '$($_.DesiredValue)'";
		New-Item -Path $_.Path -Force;
	}
	Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.DesiredValue;
}

Write-Host -ForegroundColor Green "$StepName - Done";
