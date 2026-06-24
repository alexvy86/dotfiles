---
name: az-use
description: >-
  Use when running Azure CLI (`az`) commands, including Azure DevOps (`az repos`, `az boards`, `az pipelines`).
  Verify subcommand syntax with `--help` before guessing flags. On Windows, pass any multiline flag value
  via az's `"@<file>"` file-input convention, never as a direct flag value.
---

# az-use

## Verify command syntax before running (inspect before act)

**Never guess `az` subcommand flags from memory. Run `az <command> --help` first whenever you are not certain
of the exact parameters.** Flags vary per subcommand and assumptions are frequently wrong.

Examples of easy mistakes (all avoidable by checking `--help` first):

- `az repos pr show` takes `--org` and `--id`; it does **not** take `--project`.
- Azure DevOps org URLs use the form `https://dev.azure.com/<org>` — **not** `https://<org>.visualstudio.com`
  or `https://<org>.visualstudio.com/<project>`.

## Multiline flag values on Windows

**Windows rule: any `az` flag that will receive multiline text must use the `"@<file>"` file-input convention.**
Never pass multiline text as a direct flag value on Windows.

Why: `az` on Windows is `az.cmd` (a batch wrapper).
Arguments pass through both PowerShell and CMD parsers, which silently truncates or corrupts multiline text
before `az` ever sees it.
The `"@<file>"` convention bypasses both parsers entirely — `az` reads the file directly.

Note: since `@` is PowerShell's splatting operator the path must always be **quoted** so PowerShell doesn't act on it: `"@$PWD\az-body.json"`.

Common examples affected: `az repos pr create --description`, `az boards work-item create --description`, `az rest --body`.

## Required Windows pattern (PowerShell)

Serialize the payload to a UTF-8 (no BOM) JSON file, then pass it to `az` with the `"@<file>"` convention.

```powershell
$body = @{
  description = $textWithNewlines
  # ...other required fields for the command you are running...
}

$json = $body | ConvertTo-Json -Depth 20
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText("$PWD\az-body.json", $json, $utf8NoBom)

az <command> <other-flags> --<text-flag> "@$PWD\az-body.json"
```
