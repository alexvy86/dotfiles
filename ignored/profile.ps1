#----------------------------------------------------------
# Modules
#----------------------------------------------------------
Import-Module Terminal-Icons;
Import-Module posh-git;
Import-Module git-aliases -DisableNameChecking;

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
fnm env --use-on-cd | Out-String | Invoke-Expression;

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
