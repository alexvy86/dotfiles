<!-- markdownlint-configure-file { "MD024": { "siblings_only": true } } -->

# Dotfiles

My `dotfiles` repository, managed with [ChezMoi](https://www.chezmoi.io/).

## 0. Pre-requisites

### Unix

The following packages should be installed with your package manager of choice:

- `curl`

### Windows

Install from the Microsoft Store:

- The `App Installer` app.
  It includes the `winget` executable used by this `chezmoi` repo to install other apps.
  I haven't found a way to automate its installation here, so it needs to be done manually beforehand.
  - Also make sure to run a command like `winget list --exact Microsoft.PowerShell` to get prompted to accept the source agreement terms.

NOTE: at some point I suggested that the `PowerShell` app also be installed from the Microsof Store but
then became aware of some [limitations](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#installing-from-the-microsoft-store).
Now the chezmoi setup installs the `PowerShell` MSIX through `winget`.

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

NOTE: the same command can be used to update chezmoi in Windows, since `chezmoi upgrade` in Windows is apparently not fully functional.

## 2. Install the dotfiles

Regardless of the OS, make sure the path where `chezmoi` was installed is in your PATH.

### Unix and Windows

NOTE: for my setup, I have to split the `init` and the `apply` commands so the `sourceDir` I override in the chezmoi config file takes effect during `apply`.
`--guess-repo-url=false` is necessary because otherwise chezmoi rewrites the repo URL in a way that tries to authenticate to the repo, which is public,
so there is no need to authenticate.

```bash
chezmoi init --apply=false --guess-repo-url=false --verbose https://github.com/alexvy86/dotfiles.git
chezmoi apply
```

## Testing changes to the main chezmoi config template

This command is useful for testing changes to the `.chezmoi.yaml.tmpl` file, since space-handling with the template syntax is a *pain* to use correctly.

### Unix

```bash
cat /path/to/.chezmoi.yaml.tmpl | chezmoi execute-template --init
```

### Windows

```PowerShell
Get-Content -Path /path/to/.chezmoi.yaml.tmpl | chezmoi execute-template --init
```

`chezmoi execute-template --init` can also take `--promptString <name>=<value>` but it also applies to the `promptString` function inside a template, not to `promptStringOnce`.

## Notes

For Windows systems, [the Windows Terminal settings][windows-terminal-settings-file] assume that the Ubuntu distribution
for WSL has been installed from the Microsoft Store.
If that's not the case, the profile to launch Ubuntu might not show up in the profile dropdown in Windows Terminal.

<!-- Links -->
[windows-terminal-settings-file]: ./windows/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
