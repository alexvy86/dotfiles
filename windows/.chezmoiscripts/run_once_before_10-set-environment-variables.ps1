$StepName = "Set environment variables";
Write-Host -ForegroundColor Cyan $StepName;

$script:tools_path = $env:WIN_TOOLS_PATH;

$script:current_path = [Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User);

# Consider when it's at the beginning/middle, or at the end (no trailing semicolon)
if ($script:current_path.Contains("$script:tools_path;") -Or $script:current_path.EndsWith($script:tools_path)) {
    Write-Host "'$script:tools_path' is already in the user's PATH";
    Write-Host -ForegroundColor Green "$StepName - Done";
    exit 0;
}

Write-Host "Adding '$script:tools_path' to the beginning of the user's PATH";
[Environment]::SetEnvironmentVariable("PATH", "$script:tools_path;$script:current_path", [EnvironmentVariableTarget]::User);

# Things that might be useful to get out of the C: drive if they're used.
# Need to think if I want to ask for paths for each and set them every time, or how to selectively ask for them.
# - CYPRESS_CACHE_FOLDER     : Cypress' binary cache folder (https://docs.cypress.io/guides/references/advanced-installation#Binary-cache)
# - npm_config_cache         : NPM's package cache folder (https://docs.npmjs.com/cli/v6/using-npm/config#cache)
# - NUGET_HTTP_CACHE_PATH    : "http-cache" used by Nuget and the dotnet tool (https://learn.microsoft.com/en-us/nuget/consume-packages/managing-the-global-packages-and-cache-folders)
# - NUGET_PACKAGES           : "global-packages" where Nuget installs any downloaded package (https://learn.microsoft.com/en-us/nuget/consume-packages/managing-the-global-packages-and-cache-folders)
# - NUGET_PLUGINS_CACHE_PATH : "plugins-cache" (https://learn.microsoft.com/en-us/nuget/consume-packages/managing-the-global-packages-and-cache-folders)
# - PIP_CACHE_DIR            : (https://pip.pypa.io/en/stable/cli/pip/#cmdoption-cache-dir and https://pip.pypa.io/en/stable/topics/configuration/#environment-variables)
# - PIPENV_CACHE_DIR         : https://pipenv.pypa.io/en/stable/configuration/#changing-cache-location

Write-Host -ForegroundColor Green "$StepName - Done";
