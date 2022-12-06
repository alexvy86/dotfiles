# TO-DO

- Install `posh-git` in PowerShell in Windows.
- Set up for [`oh-my-posh`](https://ohmyposh.dev/) in Windows.
  - Do not forget to update PS profile file with the env variable to make it use `posh-git`
- Set up for Windows Terminal profiles.
- Copy my script to create Edge cleanup task in Windows.
  - Even necessary still? Was it only because of Edge-Dev/Beta?
- Use `scriptEnv` to avoid some `.tmpl` files. Example [here](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#understand-how-scripts-work#set-environment-variables).
- Fix PowerShell setup. Maybe need to install `pwsh` as a separate step before `chezmoi apply`, because otherwise it's not being found in the path during during the same session where it gets installed.

## Maybe

- Support Windows PowerShell in addition to PowerShell core.
- Use `.chezmoiignore` to handle per-OS configuration. Example [here](https://github.com/twpayne/dotfiles/commit/c550eddaf5d1cb2d3f105e10bfb305f370ee177c).
- Make it so output of `ps1` scripts that run in elevated command prompt is also visible in the output of the console
  that called them.
