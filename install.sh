#!/bin/sh

# chezmoi install script for codespaces
# https://www.chezmoi.io/user-guide/machines/containers-and-vms/

set -e # -e: exit on error

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://chezmoi.io/get)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

# Init first to generate the chezmoi config file, which in my case overrides the sourceDir
# based on the OS.
"$chezmoi" init "--source=$script_dir" ;

# Now run the actual chezmoi apply. exec will replace the current process with the one running chezmoi.
exec "$chezmoi" apply --debug ;
