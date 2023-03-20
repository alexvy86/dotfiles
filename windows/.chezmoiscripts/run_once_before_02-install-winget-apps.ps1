$Packages = @(
	"Microsoft.PowerToys",
	"Git.Git",
	"GitHub.GitLFS",
	"JanDeDobbeleer.OhMyPosh"
	# "Docker.DockerDesktop",
	# "Google.Chrome",
	# "PuTTY.PuTTY",
	# "Notepad++.Notepad++",
	# "Microsoft.VisualStudioCode",
	# "VideoLAN.VLC",
	);

$Packages |% {
	winget list --exact $_ > $null;
	if ($LastExitCode -eq 0) {
		Write-Host "Package $_ is already installed";
	} else {
		Write-Host "Installing package $_";
		winget install $_ -s winget;
	}
}
