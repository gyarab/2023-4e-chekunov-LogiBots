#!/bin/sh
echo -ne '\033c\033]0;Logibots\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/testRelease5.x86_64" "$@"
