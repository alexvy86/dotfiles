# Dotfiles

My `dotfiles` repository, managed with [ChezMoi](https://www.chezmoi.io/).

## 1. Install chezmoi

General instructions [here](https://www.chezmoi.io/install/).

### Unix

Run the folowing line in the console

```bash
sh -c "$(curl -fsLS https://chezmoi.io/get)";
```

### Windows

Run the following line exactly as is (just replace the `<target-path-for-chezmoi.exe>` with the desired location, e.g. `D:\Users\alexv\Tools`) on a PowerShell console.

```PowerShell
'$params = "-BinDir <target-path-for-chezmoi.exe>"', (Invoke-RestMethod -UseBasicParsing https://chezmoi.io/get.ps1) | powershell -Command - ;
```

If everything before the comma is ommitted, the default installation is to `$($env:USERPROFILE)/bin`.

The command will print where it installed the binary to.

## 2. Install the dotfiles

### Unix and Windows

```bash
chezmoi init --apply --verbose https://github.com/alexvy86/dotfiles.git
```
