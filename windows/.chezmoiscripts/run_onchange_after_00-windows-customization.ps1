$StepName = "Updating registry settings";
Write-Host -ForegroundColor Cyan $StepName;

$settingsToChange = @();

# Disable browser tabs showing up in Alt-Tab. Applies to Windows 10 and 11.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
	Name         = "MultiTaskingAltTabFilter";
	DesiredValue = 3;
};

# TODO: trying to set this specific Name fails with "Set-ItemProperty: Attempted to perform an unauthorized operation."
# Seems like it's due to Microsoft restricting which apps can change this setting:
# https://www.elevenforum.com/t/enable-or-disable-userchoice-protection-driver-ucpd-in-windows-11-and-10.24267/
# https://forums.mydigitallife.net/threads/taskbarda-widgets-registry-change-is-now-blocked.88547
# Maybe the solution here would work:
# https://forums.mydigitallife.net/threads/taskbarda-widgets-registry-change-is-now-blocked.88547/#post-1849025
# For now I have to disable it manually from Taskbar Settings.
# # Hide the "Widgets" button in the taskbar. Applies to Windows 11.
# $settingsToChange += @{
# 	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
# 	Name         = "TaskbarDa";
# 	DesiredValue = 0;
# };

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

# Disable transparency effects in Windows 11
# Just don't like it, plus it seems to imagine things or cache backgrounds that aren't there anymore.
$settingsToChange += @{
	Path         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";
	Name         = "EnableTransparency";
	DesiredValue = 0;
};

# TODO: set key to cause SSH connections into a PC to run bash.exe instead of cmd.exe, i.e. conncet to WSL2
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\WINDOWS\System32\bash.exe" -PropertyType String -Force

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
		} else {
			Write-Host "Creating new registry entry at $($_.Path) -> $($_.Name) with value '$($_.DesiredValue)'";
		}
	} else {
		Write-Host "Creating new registry entry at $($_.Path) -> $($_.Name) with value '$($_.DesiredValue)'";
		New-Item -Path $_.Path -Force;
	}
	Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.DesiredValue;
}

Write-Host -ForegroundColor Green "$StepName - Done";
