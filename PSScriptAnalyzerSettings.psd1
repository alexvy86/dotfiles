@{
    # Run the default PSScriptAnalyzer rule set, minus rules that conflict with
    # deliberate conventions in this repo. See .github/workflows/lint.yml.
    ExcludeRules = @(
        # Setup scripts intentionally use Write-Host for coloured, user-facing
        # console output (progress/status), not pipeline data.
        'PSAvoidUsingWriteHost'

        # Stylistic only; these interactive-style scripts favour terse calls.
        'PSAvoidUsingPositionalParameters'
        'PSAvoidUsingCmdletAliases'

        # Renaming functions to singular nouns would break documented commands
        # (e.g. 'install-apps' referenced in the README).
        'PSUseSingularNouns'

        # -WhatIf/-Confirm plumbing is overkill for one-shot machine setup scripts.
        'PSUseShouldProcessForStateChangingFunctions'

        # UTF-8 without a BOM is correct for PowerShell 7 and matches .editorconfig.
        'PSUseBOMForUnicodeEncodedFile'
    )
}
