#!/usr/bin/env bash
set -euo pipefail
source "$HOME/.config/rea/environment.sh"
rea doctor --client codex --provider ghidra --provider jadx --skill --json > /tmp/rea-final-doctor.json
python3 -c 'import json;d=json.load(open("/tmp/rea-final-doctor.json"));print("CLOUD_HEALTHY",d.get("healthy"));print("PROVIDERS",d.get("availableProviders"));s=json.load(open("/tmp/rea-smoke.json"));print("JS_EVIDENCE",s.get("evidence_id"))'
google-chrome --version
javac -version
adb version | head -1
tshark --version | head -1
mkdir -p /tmp/rea-native-smoke
printf '%s\n' 'int tao_add(int a,int b){return a+b;} int main(void){return tao_add(2,3);}' > /tmp/rea-native-smoke/tao.c
cc -O0 -g /tmp/rea-native-smoke/tao.c -o /tmp/rea-native-smoke/tao
rea decompile /tmp/rea-native-smoke/tao tao_add --provider ghidra --json > /tmp/rea-native-smoke.json
python3 -c 'import json;d=json.load(open("/tmp/rea-native-smoke.json"));print("NATIVE_RESULT",str(d)[:1000])'
echo REA_VERIFY_PASS
