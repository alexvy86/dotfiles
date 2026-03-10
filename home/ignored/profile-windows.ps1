#----------------------------------------------------------
# Windows-specific Aliases
#----------------------------------------------------------

# Chezmoi commmands
function private:cuaf {
	chezmoi update --apply=false;
}

# Interactive winget upgrader.
# Uses fzf for multi-select (Tab/Space to select, Enter to upgrade, Esc to cancel).
function private:wingetup {
    Write-Host "Fetching available upgrades..." -ForegroundColor Cyan

    # Strip ANSI codes and trailing CR; drop spinner/blank lines
    $rawOutput = winget list --upgrade-available --accept-source-agreements 2>&1 |
        Where-Object { $_ -is [string] } |
        ForEach-Object { ($_ -replace '\x1b\[[0-9;]*[A-Za-z]', '').TrimEnd("`r") } |
        Where-Object { $_ -match '\S' }

    # Find the header line by content (more reliable than the solid-dash separator)
    $headerLineIdx = -1
    for ($i = 0; $i -lt $rawOutput.Count; $i++) {
        if ($rawOutput[$i] -match '\bName\b.*\bId\b.*\bVersion\b') { $headerLineIdx = $i; break }
    }

    if ($headerLineIdx -lt 0 -or $headerLineIdx -ge ($rawOutput.Count - 2)) {
        Write-Host "No upgrades available." -ForegroundColor Green
        return
    }

    # Derive column start positions from the header words
    $headerLine = $rawOutput[$headerLineIdx]
    $colStarts  = [System.Collections.Generic.List[int]]::new()
    $colNames   = [System.Collections.Generic.List[string]]::new()
    $i = 0
    while ($i -lt $headerLine.Length) {
        if ($headerLine[$i] -ne ' ') {
            $colStarts.Add($i)
            $word = ""
            while ($i -lt $headerLine.Length -and $headerLine[$i] -ne ' ') { $word += $headerLine[$i]; $i++ }
            $colNames.Add($word)
        } else { $i++ }
    }

    $nameIdx      = $colNames.IndexOf("Name")
    $idIdx        = $colNames.IndexOf("Id")
    $versionIdx   = $colNames.IndexOf("Version")
    $availableIdx = $colNames.IndexOf("Available")

    if ($idIdx -lt 0) {
        Write-Host "Could not parse winget output (no Id column found)." -ForegroundColor Red
        return
    }

    # Extract a field from a data line by column index
    $getField = {
        param([string]$line, [int]$colIdx)
        $start = $colStarts[$colIdx]
        $end   = if ($colIdx + 1 -lt $colStarts.Count) { $colStarts[$colIdx + 1] } else { $line.Length }
        $end   = [Math]::Min($end, $line.Length)
        if ($start -ge $line.Length) { return "" }
        $line.Substring($start, $end - $start).Trim()
    }

    # Data rows start after header + separator; skip non-package lines:
    #   - "N upgrades available" summary
    #   - secondary section separator lines (all dashes)
    #   - secondary section header ("Name  Id  Version ...")
    #   - secondary section preamble text ("The following packages...")
    # The final filter ensures Available looks like a version number, which catches
    # any remaining non-package lines that slipped through.
    $packages = $rawOutput[($headerLineIdx + 2)..($rawOutput.Count - 1)] |
        Where-Object {
            $_ -notmatch '^\d+ upgrade' -and
            $_ -notmatch '^\s*-[-\s]*$' -and
            $_ -notmatch '\bName\b.*\bId\b.*\bVersion\b'
        } |
        ForEach-Object {
            $line = $_
            [PSCustomObject]@{
                Name      = & $getField $line $nameIdx
                Id        = & $getField $line $idIdx
                Version   = & $getField $line $versionIdx
                Available = & $getField $line $availableIdx
            }
        } |
        Where-Object { $_.Id -and $_.Available -match '^\d' }

    if (!$packages -or @($packages).Count -eq 0) {
        Write-Host "No upgrades available." -ForegroundColor Green
        return
    }

    # Build tab-delimited lines: <Id><TAB><display>
    # fzf shows only the display part (--with-nth=2), but the full line is returned on selection.
    $maxNameLen = ($packages | ForEach-Object { $_.Name.Length } | Measure-Object -Maximum).Maximum
    $fzfLines = $packages | ForEach-Object {
        $display = "$($_.Name.PadRight($maxNameLen))  $($_.Version) -> $($_.Available)"
        "$($_.Id)`t$display"
    }

    $selected = $fzfLines | fzf `
        --multi `
        --delimiter="`t" `
        --with-nth=2 `
        --header="TAB/SPACE: select  ENTER: upgrade  ESC: cancel" `
        --height=~80% `
        --layout=reverse

    if (!$selected) {
        Write-Host "No packages selected." -ForegroundColor Yellow
        return
    }

    $selectedIds = @($selected) | ForEach-Object { ($_ -split "`t")[0] }

    Write-Host ""
    foreach ($id in $selectedIds) {
        Write-Host "==> Upgrading: $id" -ForegroundColor Yellow
        winget upgrade --id $id --accept-source-agreements --accept-package-agreements
        Write-Host ""
    }
    Write-Host "Done." -ForegroundColor Green
}

# TODO: would this work in Linux?
# Alias for SSH to auto-load ssh keys on first use and keep them in the agent for 10 hrs.
# function private:ssh {param($params);
# 	(ssh-add -l | Out-Null || (ssh-add -t 10h && Write-Host -ForegroundColor Green "ssh-key(s) are now available in ssh-agent for 10 hrs!`n")) && ssh $params;
# }

function private:add-ssh-keys {
	Write-Warning "The keys will be added to the agent permanently until you remove them";
	# As of 2025-11-29, the -t flag of ssh-add is not supported on Windows.
	# See https://github.com/PowerShell/Win32-OpenSSH/issues/1056 for details.
	# ssh-add -t 4h
	ssh-add
}

function private:remove-ssh-keys {
	ssh-add -D
}

function private:install-apps {
	param(
		[switch]$personal
	)

	$PathToGitInstallerSettings = Join-Path -Path $env:USERPROFILE -ChildPath ".config/git-for-windows-installer-settings.ini";
	$PathToVsCodeInstallerSettings = Join-Path -Path $env:USERPROFILE -ChildPath ".config/vscode-installer-settings.ini";

	$ApplicationsToInstall = @(
		@{Id = "7zip.7zip"; }
		@{Id = "AgileBits.1Password"; }
		@{Id = "Git.Git"; Args = "/SILENT /LOADINF=$PathToGitInstallerSettings" }
		@{Id = "GitHub.GitLFS"; }
		# Google.Chrome.EXE (vs Google.Chrome) does a user-level install
		@{Id = "Google.Chrome.EXE"; }
		@{Id = "JanDeDobbeleer.OhMyPosh"; }
		@{Id = "Microsoft.Edge.Dev"; }
		@{Id = "Microsoft.VisualStudioCode"; Args = "/SILENT /LOADINF=$PathToVsCodeInstallerSettings" }
		@{Id = "Microsoft.WindowsTerminal"; }
		# @{Id="Docker.DockerDesktop",
	);

	$MSStoreApplications = @(
		@{Id = "9NBLGGH4NNS1"; Name = "App Installer" }
		@{Id = "9PGCV4V3BK4W"; Name = "Dev Toys" }
		@{Id = "9P7KNL5RWT25"; Name = "Sysinternals Suite" }
	);

	if ($personal) {
		$ApplicationsToInstall += @(
			@{Id = "Discord.Discord" }
			@{Id = "PrivateInternetAccess.PrivateInternetAccess" }
			@{Id = "Spotify.Spotify" }
			@{Id = "Tailscale.Tailscale" }
			@{Id = "Valve.Steam" }
			@{Id = "Windscribe.Windscribe" }
		);

		$MSStoreApplications += @(
			@{Id = "9NKSQGP7F2NH"; Name = "WhatsApp" }
		);
	}

	Write-Host -ForegroundColor Cyan "Installing packages from source 'winget'";

	foreach ($app in $ApplicationsToInstall) {
		winget list --exact --id $app.Id --source winget > $null;
		if ($LastExitCode -eq 0) {
			Write-Host "Winget package $($app.Id) is already installed";
		} else {
			Write-Host "Installing Winget package $($app.Id)";
			if (-not $app.ContainsKey("Args") -or $null -eq $app.Args) {
				winget install --exact --id $app.Id --source winget;
			} else {
				winget install --exact --id $app.Id --source winget --override "$($app.Args)";
			}
		}
	}

	Write-Host -ForegroundColor Cyan "Installing applications from source 'msstore'";

	foreach ($app in $MSStoreApplications) {
		winget list --exact --id $app.Id --source msstore > $null;
		if ($LastExitCode -eq 0) {
			Write-Host "Package $($app.Name) ($($app.Id)) is already installed";
		} else {
			Write-Host "Installing MSStore app $($app.Name) ($($app.Id))";
			winget install --exact --id $app.Id --source msstore --accept-package-agreements --accept-source-agreements;
		}
	}
}
