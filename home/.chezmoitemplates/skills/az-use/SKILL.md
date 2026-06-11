---
name: az-use
description: >-
  Use when running Azure CLI (`az`) on Windows and any flag value may contain
  multiline text. On Windows, always write multiline content to a file and
  pass it with az's `"@<file>"` convention. Never pass multiline text directly
  as a flag value.
---

# az-use

**Windows rule: any `az` flag that will receive multiline text must use the
`"@<file>"` file-input convention.** Never pass multiline text as a direct flag
value on Windows.

Why: `az` on Windows is `az.cmd` (a batch wrapper). Arguments pass through both
PowerShell and CMD parsers, which silently truncates or corrupts multiline text
before `az` ever sees it. The `"@<file>"` convention bypasses both parsers
entirely — `az` reads the file directly.

Note: since `@` is PowerShell's splatting operator the path must always be
**quoted** so PowerShell doesn't act on it: `"@$PWD\az-body.json"`.

Common examples affected: `az repos pr create --description`,
`az boards work-item create --description`, `az rest --body`.

## Required Windows pattern (PowerShell)

Serialize the payload to a UTF-8 (no BOM) JSON file, then pass it to `az` with
the `"@<file>"` convention.

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
