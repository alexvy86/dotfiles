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

NOTE: for my setup, I have to split the `init` and the `apply` commands so the `sourceDir` I override in the chezmoi config file takes effect during `apply`.

```bash
chezmoi init --apply=false --verbose https://github.com/alexvy86/dotfiles.git
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
