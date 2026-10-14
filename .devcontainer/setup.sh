#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y procps unzip file binutils gdb adb apktool python3-venv
npm install --global rea-agents@6.5.0 @openai/codex
mkdir -p "$HOME/.local/share/rea/providers"
provider_root="$HOME/.local/share/rea/providers"
if [ ! -x "$provider_root/ghidra_12.1.4_PUBLIC/support/analyzeHeadless" ]; then
  archive=$(mktemp)
  curl -fL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.4_build/ghidra_12.1.4_PUBLIC_20260921.zip -o "$archive"
  echo "ddac49f903da9d5bac833e5cc79395098b9c33cfd3279be5f31bd00387d2d4db  $archive" | sha256sum -c -
  unzip -q "$archive" -d "$provider_root"
  rm "$archive"
fi
export GHIDRA_INSTALL_DIR="$provider_root/ghidra_12.1.4_PUBLIC"
rea setup --client codex --yes --json
rea doctor --client codex --provider ghidra --skill --json > /tmp/rea-doctor.json
fixture=$(mktemp -d)
printf '%s\n' '{"name":"rea-smoke","version":"1.0.0","type":"module","main":"index.js"}' > "$fixture/package.json"
printf '%s\n' 'export function add(a,b){return a+b}' > "$fixture/index.js"
rea analyze-javascript-application "$fixture" --json > /tmp/rea-smoke.json
echo "REA setup complete. Diagnostics: /tmp/rea-doctor.json; smoke analysis: /tmp/rea-smoke.json"
