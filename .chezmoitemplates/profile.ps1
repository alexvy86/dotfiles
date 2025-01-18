Set-StrictMode -Version Latest;

# Auto-completions for Winget
# https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)
			[Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
			$Local:word = $wordToComplete.Replace('"', '""')
			$Local:ast = $commandAst.ToString().Replace('"', '""')
			winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
					[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
			}
}

# TODO: There might be something interesting we can do with $PSDefaultParameterValues

#----------------------------------------------------------
# Modules
#----------------------------------------------------------
# Disabling Terminal-Icons until they fix their performance issues.
# It adds ~800ms to my profile load time on Windows (didn't check Linux since I use zsh there).
# See https://github.com/devblackops/Terminal-Icons/issues/76
# Import-Module Terminal-Icons;

# Load this module explicitly before git-aliases so it creates the gcb alias (Get-Clipboard),
# and git-aliases can override it.
Import-Module Microsoft.PowerShell.Management;

Import-Module git-aliases -DisableNameChecking;

# Arguments: $ForcePoshGitPrompt, $UseLegacyTabExpansion, $EnableProxyFunctionExpansion
Import-Module posh-git -ArgumentList @($false, $false, $true);
Import-Module DockerCompletion;

#----------------------------------------------------------
# PSReadLine, see https://github.com/PowerShell/PSReadLine
#----------------------------------------------------------

# Windows-style default key handlers.
Set-PSReadLineOption -EditMode Windows;

# Make sure the cursor goes to the end of the line on history search.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd;

Set-PSReadLineOption -PredictionSource HistoryAndPlugin;
Set-PSReadLineOption -PredictionViewStyle ListView;

# Trying to make Linux and Windows as similar as possible for the things I use.
# REMEMBER KEY HANDLERS ARE CASE SENSITIVE. Ctrl+v and Ctrl+V are different handlers.

Set-PSReadlineKeyHandler -Chord Tab            	-Function MenuComplete;
Set-PSReadlineKeyHandler -Chord Ctrl+Backspace 	-Function BackwardKillWord
Set-PSReadlineKeyHandler -Chord Ctrl+Delete    	-Function KillWord;
Set-PSReadlineKeyHandler -Chord Ctrl+u          -Function BackwardKillInput;
Set-PSReadlineKeyHandler -Chord Ctrl+k          -Function KillLine;
Set-PSReadlineKeyHandler -Chord Ctrl+a         	-Function SelectAll;
Set-PSReadlineKeyHandler -Chord Ctrl+C         	-Function Copy;
Set-PSReadlineKeyHandler -Chord Ctrl+v         	-Function Paste;
Set-PSReadlineKeyHandler -Chord Ctrl+y         	-Function Redo;
Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow 	-Function BackwardWord;
Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function NextWord;

# These are normally bound to F8 and Shift+F8. More convenient to just have them in the arrows.
Set-PSReadLineKeyHandler -Chord UpArrow         -Function HistorySearchBackward;
Set-PSReadLineKeyHandler -Chord DownArrow       -Function HistorySearchForward;

# VSCode usually eats these but might as well have them defined
Set-PSReadLineKeyHandler -Chord PageDown        -Function ScrollDisplayDown;
Set-PSReadLineKeyHandler -Chord Ctrl+PageDown   -Function ScrollDisplayDownLine;
Set-PSReadLineKeyHandler -Chord PageUp          -Function ScrollDisplayUp;
Set-PSReadLineKeyHandler -Chord Ctrl+PageUp     -Function ScrollDisplayUpLine;

#----------------------------------------------------------
# FNM
#----------------------------------------------------------
# Assumes it was installed earlier.
{{ if (eq .chezmoi.os "windows") -}}
fnm env --use-on-cd --shell "power-shell" | Out-String | Invoke-Expression;
{{- else -}}
fnm env --use-on-cd | Out-String | Invoke-Expression;
{{- end }}

#----------------------------------------------------------
# Prompt
#----------------------------------------------------------
oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;

#oh-my-posh init pwsh --config "~/.poshthemes/slimfat.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/takuya.omp.json" | Invoke-Expression;

#oh-my-posh init pwsh --config "~/.poshthemes/bubblesextra.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/lambdageneration.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/multiverse-neon.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/stelbent-compact.minimal.omp.json" | Invoke-Expression;
