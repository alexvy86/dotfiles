# This is the "Current user, all hosts" PowerShell profile file so it applies # to all host applications that host
# PowerShell (e.g. PowerShell ISE, VSCode).

# Import-Module Terminal-Icons;
# Import-Module posh-git;
# Import-Module git-aliases -DisableNameChecking;

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

# Initialize oh-my-posh
oh-my-posh init pwsh --config "~/.config/alexvy86.omp.json" | Invoke-Expression;

#oh-my-posh init pwsh --config "~/.poshthemes/slimfat.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/takuya.omp.json" | Invoke-Expression;

#oh-my-posh init pwsh --config "~/.poshthemes/bubblesextra.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/lambdageneration.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/multiverse-neon.omp.json" | Invoke-Expression;
#oh-my-posh init pwsh --config "~/.poshthemes/stelbent-compact.minimal.omp.json" | Invoke-Expression;
