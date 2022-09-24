# This is intended to be sounced by the "Current user, all hosts" PowerShell profile file so it applies
# to all host applications that host PowerShell (e.g. PowerShell ISE, VSCode).
# In the actual file (which should be at $profile.CurrentUserAllHosts, almost certainly under your
# user's Documents folder), source this file as follows:
#
# . <path-to-this-file>
#
# E.g.
#
# . "$HOME\.config\powershell\profile.ps1";.
#
# Done this way instead of directly creating the file because I have setups where the actual file
# lives in another drive and I can't update it easily with chezmoi.

Import-Module posh-git;

##
# PSReadLine, see https://github.com/PowerShell/PSReadLine
##

## Make Tab behave like Ctrl+space for autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete;

## These are normally bound to F8 and Shift+F8. More convenient to just have them in the arrows.
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward;
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward;

Set-PSReadLineOption -PredictionSource History;