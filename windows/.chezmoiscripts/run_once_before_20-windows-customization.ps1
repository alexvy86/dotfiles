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

# Apply registry changes
$settingsToChange | ForEach-Object {
	$currentValue = Get-ItemPropertyValue -Path $_.Path -Name $_.Name;
	Write-Host "$($_.Path)/$($_.Name) - Current value: $currentValue - New value: $($_.DesiredValue)";
	Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.DesiredValue;
}

Write-Host -ForegroundColor Green "$StepName - Done";
