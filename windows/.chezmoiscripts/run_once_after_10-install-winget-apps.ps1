$StepName = "Installing regular applications with winget";
Write-Host -ForegroundColor Cyan $StepName;

$PathToGitInstallerSettings = Join-Path -Path $env:USERPROFILE -ChildPath ".config/git-for-windows-installer-settings.ini";
$PathToVsCodeInstallerSettings = Join-Path -Path $env:USERPROFILE -ChildPath ".config/vscode-installer-settings.ini";

$ApplicationsToInstall = @(
	@{Id = "Microsoft.WindowsTerminal"; },
	@{Id = "7zip.7zip"; },
	@{Id = "Git.Git"; Args = "/SILENT /LOADINF=$PathToGitInstallerSettings" },
	@{Id = "GitHub.GitLFS"; },
	@{Id = "JanDeDobbeleer.OhMyPosh"; },
	@{Id = "Microsoft.VisualStudioCode"; Args = "/SILENT /LOADINF=$PathToVsCodeInstallerSettings" },
	@{Id = "Microsoft.Edge.Dev"; },
	# Google.Chrome.EXE (vs Google.Chrome) does a user-level install
	@{Id = "Google.Chrome.EXE"; },
	@{Id = "AgileBits.1Password"; }
	# @{Id = "ScooterSoftware.BeyondCompare4"; }
	# @{Id="Docker.DockerDesktop",
	# @{Id="Microsoft.AzureCLI",
	# @{Id="PuTTY.PuTTY",
	# @{Id="Notepad++.Notepad++",
	# @{Id="VideoLAN.VLC",
	# @{Id="Discord.Discord",
	# @{Id="PrivateInternetAccess.PrivateInternetAccess",
	# @{Id="Windscribe.Windscribe",
	# @{Id="Spotify.Spotify",
	# @{Id="Valve.Steam",
	# @{Id="tailscale.tailscale",
);

foreach ($app in $ApplicationsToInstall) {
	winget list --exact --id $app.Id --source winget > $null;
	if ($LastExitCode -eq 0) {
		Write-Host "Package $($app.Id) is already installed";
	} else {
		Write-Host "Installing package $($app.Id)";
		if ($null -eq $app.Args) {
			winget install --exact --id $app.Id --source winget;
		} else {
			winget install --exact --id $app.Id --source winget --override "$($app.Args)";
		}
	}
}

Write-Host -ForegroundColor Green "$StepName - Done";
