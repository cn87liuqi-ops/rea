#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y procps unzip file binutils gdb adb apktool python3-venv tshark sigrok-cli
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
export REA_JADX_MCP_JAR="$provider_root/jadx-headless-mcp-0.7.1-all.jar"
if [ ! -f "$REA_JADX_MCP_JAR" ]; then
  curl -fL https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar -o "$REA_JADX_MCP_JAR"
fi
echo "6e5eacf500b64292bfb73c49797c1958f6ee44646e43e868039ae7feb573ff75  $REA_JADX_MCP_JAR" | sha256sum -c -
mkdir -p "$HOME/.config/rea"
printf 'export GHIDRA_INSTALL_DIR="%s"\nexport REA_JADX_MCP_JAR="%s"\n' "$GHIDRA_INSTALL_DIR" "$REA_JADX_MCP_JAR" > "$HOME/.config/rea/environment.sh"
if ! grep -q '.config/rea/environment.sh' "$HOME/.bashrc"; then
  echo 'source "$HOME/.config/rea/environment.sh"' >> "$HOME/.bashrc"
fi
rea setup --client codex --yes --json
rea doctor --client codex --provider ghidra --skill --json > /tmp/rea-doctor.json
fixture=$(mktemp -d)
printf '%s\n' '{"name":"rea-smoke","version":"1.0.0","type":"module","main":"index.js"}' > "$fixture/package.json"
printf '%s\n' 'export function add(a,b){return a+b}' > "$fixture/index.js"
rea analyze-javascript-application "$fixture" --json > /tmp/rea-smoke.json
echo "REA setup complete. Diagnostics: /tmp/rea-doctor.json; smoke analysis: /tmp/rea-smoke.json"
