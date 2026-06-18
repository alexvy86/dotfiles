#!/usr/bin/env bash
# Post-apply verification for Unix targets.
#
# Asserts that `chezmoi apply` produced the files we expect, rather than just
# checking that the command exited 0. This exercises three things the CI smoke
# test otherwise can't see: template rendering, external downloads, and the
# platform isolation logic in .chezmoiignore.
#
# Run from the repo root: bash tests/verify-unix.sh
# Not '-e': we want every assertion to run so a single failure doesn't hide the rest.
set -uo pipefail

failures=0

pass() { printf '  ok   %s\n' "$1"; }
fail() {
  printf '  FAIL %s\n' "$1"
  failures=$((failures + 1))
}

assert_exists() {
  if [ -e "$1" ]; then pass "$2"; else fail "$2 -- missing: $1"; fi
}

assert_executable() {
  if [ -x "$1" ]; then pass "$2"; else fail "$2 -- not executable: $1"; fi
}

assert_absent() {
  if [ ! -e "$1" ]; then pass "$2"; else fail "$2 -- should not exist: $1"; fi
}

assert_contains() {
  if [ -f "$1" ] && grep -q "$2" "$1"; then
    pass "$3"
  else
    fail "$3 -- pattern '$2' not found in: $1"
  fi
}

echo "Managed dotfiles:"
assert_exists   "${HOME}/.gitconfig"                              ".gitconfig applied"
assert_contains "${HOME}/.gitconfig" "716334+alexvy86"           ".gitconfig rendered from template"
assert_exists   "${HOME}/.gitconfig-maintenance"                  ".gitconfig-maintenance created"
assert_exists   "${HOME}/.bashrc"                                 ".bashrc applied"
assert_exists   "${HOME}/.zshrc"                                  ".zshrc applied"
assert_exists   "${HOME}/.zshenv"                                 ".zshenv applied"
assert_exists   "${HOME}/.profile"                                ".profile applied"
assert_exists   "${HOME}/.config/git/ignore"                      "global gitignore applied"
assert_exists   "${HOME}/.config/git.sh"                          "git.sh shell snippet applied"
assert_exists   "${HOME}/.claude/CLAUDE.md"                       "Claude config applied"
assert_exists   "${HOME}/.oh-my-zsh/custom/themes/alex.zsh-theme" "custom zsh theme applied"

echo "Externals:"
assert_exists     "${HOME}/.local/share/navi/cheats/git.cheat" "navi git cheat downloaded"
assert_exists     "${HOME}/.local/bin/ssh-ident"              "ssh-ident downloaded"
assert_executable "${HOME}/.local/bin/ssh-ident"              "ssh-ident is executable"
assert_exists     "${HOME}/.config/zsh/zsh-autocomplete"      "zsh-autocomplete cloned"
assert_exists     "${HOME}/.config/zsh/fzf-tab"               "fzf-tab cloned"

echo "Cross-platform isolation (Windows-only files absent):"
assert_absent "${HOME}/AppData"                    "AppData not applied on Unix"
assert_absent "${HOME}/.config/powertoys.dsc.yaml" "PowerToys config not applied on Unix"

echo
if [ "${failures}" -gt 0 ]; then
  printf '%s assertion(s) failed.\n' "${failures}"
  exit 1
fi
echo "All assertions passed."
