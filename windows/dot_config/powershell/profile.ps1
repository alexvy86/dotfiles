# This is intended to be sourced by the "Current user, all hosts" PowerShell profile file so it applies
# to all host applications that host PowerShell (e.g. PowerShell ISE, VSCode).
# In the actual file (which should be at $profile.CurrentUserAllHosts, almost certainly under your
# user's Documents folder), source this file as follows:
#
# . <path-to-this-file>
#
# E.g.
#
# . "$HOME\.config\powershell\profile.ps1";
#
# Done this way instead of directly creating the file because I have setups where the actual file
# lives in another drive and I can't update it easily with chezmoi.

Import-Module Terminal-Icons;
Import-Module posh-git;
Import-Module git-aliases -DisableNameChecking;

##
# PSReadLine, see https://github.com/PowerShell/PSReadLine
##

## Make Tab behave like Ctrl+space for autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete;

# Make sure the cursor goes to the end of the line on history search
Set-PSReadLineOption -HistorySearchCursorMovesToEnd;

Set-PSReadLineOption -PredictionSource History;

# Set up fnm. Assumes it was installed earlier.
fnm env --use-on-cd | Out-String | Invoke-Expression;
