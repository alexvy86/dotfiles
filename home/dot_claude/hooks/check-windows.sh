#!/usr/bin/env bash
# If running natively on Windows (Git Bash / MSYS2),
# inform Claude about the environment.

is_windows() {
  [[ "$OS" == "Windows_NT" ]] || [[ "$OSTYPE" == msys* ]] || [[ "$OSTYPE" == cygwin* ]]
}

is_windows || exit 0

msg="## Environment
- Running on Windows
- Default shell is Git Bash (not PowerShell)
- To use PowerShell, invoke it explicitly: \`pwsh -NoProfile -Command \"...\"\`
- Path formats: Git Bash uses \`/\` (e.g., \`/c/git/repo\`), Windows uses \`\\\` (e.g., \`C:\\git\\repo\`)

## PowerShell
Always use the \`-NoProfile\` flag when running PowerShell commands."

echo "$msg"
