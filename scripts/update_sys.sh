#!/usr/bin/bash

set -Eeuo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
assetsFolder="$SCRIPT_DIR/../assets"
sysZipFileName="sys"
sysZipFile="$assetsFolder/$sysZipFileName.zip"
rm -f "$sysZipFile"
tmpFolder=$(mktemp -d)
git clone https://github.com/JoeStrout/minimicro-sysdisk "$tmpFolder"
cd "$tmpFolder"
zip -r "$sysZipFile" "$sysZipFileName" -x "*.git*" "*.DS_Store" "README.md" "LICENSE"
rm -rf "$tmpFolder"