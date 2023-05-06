$Packages = @(
	"7zip.7zip",                      # Has UAC prompt
	"Microsoft.PowerToys",
	"Git.Git",                        # Has UAC prompt
	"GitHub.GitLFS",                  # Has UAC prompt
	"JanDeDobbeleer.OhMyPosh",
	"Microsoft.VisualStudioCode",
	"Microsoft.Edge.Dev"              # Has UAC prompt
	"Google.Chrome",
	"AgileBits.1Password",            # Has UAC prompt
	"ScooterSoftware.BeyondCompare4"  # Has UAC prompt
	# "Docker.DockerDesktop",
	# "Microsoft.AzureCLI",
	# "PuTTY.PuTTY",
	# "Notepad++.Notepad++",
	# "VideoLAN.VLC",
	# "Discord.Discord",
	# "PrivateInternetAccess.PrivateInternetAccess",
	# "Windscribe.Windscribe",
	# "Spotify.Spotify",
	# "Valve.Steam",
	# "tailscale.tailscale",
	);

$Packages | ForEach-Object {
	winget list --exact $_ > $null;
	if ($LastExitCode -eq 0) {
		Write-Host "Package $_ is already installed";
	} else {
		Write-Host "Installing package $_";
		# TODO: Use --override to do automated installations of everything, e.g. with /SILENT for VSCode or -passive for PowerToys
		winget install $_ --exact --source winget;
	}
}
