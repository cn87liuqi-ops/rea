# 陶师傅 REA 云端使用说明

更新日期：2026-10-14

## 入口
- GitHub 仓库：https://github.com/cn87liuqi-ops/rea
- 云端工作空间：https://urban-space-barnacle-p7rxgxxg55w739xpx.github.dev/

## 已完成
- Fork 官方仓库，保留上游代码。
- Codespaces：Ubuntu 24.04、Node.js 24.18.0、Java 21。
- REA 6.5.0、Codex CLI、Codex MCP 和配套技能。
- Ghidra 12.1.4、JADX headless MCP 0.7.1：下载文件已校验 SHA-256。
- Chrome、ADB、Apktool、GDB、binutils、TShark、sigrok-cli。
- 云端 doctor（Codex、Ghidra、JADX、技能）返回 healthy=true。
- JavaScript 样例分析和编译后 C 程序的 Ghidra 反编译命令均实际成功。
- 本机 REA/Codex MCP/技能安装完成，JavaScript 样例实测成功。

## 开始使用
在 Codespaces 新终端运行：

```bash
source "$HOME/.config/rea/environment.sh"
rea --help
codex login
codex
```

Codex 登录需要账号本人完成。不要将登录凭据提交到仓库。

JavaScript/Electron 静态分析：
```bash
rea analyze-javascript-application /absolute/path/to/app --json
```

原生程序：
```bash
rea analyze /absolute/path/to/program --provider ghidra --json
rea decompile /absolute/path/to/program function_name --provider ghidra --json
```

健康检查与复验：
```bash
bash .devcontainer/verify.sh
```

## 验证边界
JADX 已通过环境检查，尚未用真实 APK 完整分析。Chrome、ADB、Apktool、TShark 和 sigrok-cli 已安装；未连接实物手机或逻辑分析仪，未验证真实抓包或录波。Codespaces 无法直接读取你电脑的 USB 手机，需要另行安排设备连接。

固件专用 Binwalk/Unblob、pwntools、特定版本 WABT 等扩展尚未配置。IDA、Hopper 和 JEB 等商业工具需要用户自行提供有效许可，不包含在此次免费安装中。

这是命令行/MCP 分析环境，不是公开网页应用。云端 Codex 未登录，不能把 REA 环境就绪当作 AI 账号已可用。

## 免费额度
只使用 Codespaces 免费额度，未设置付款方式或购买付费方案。使用后从 GitHub Codespaces 页面停止工作空间，节省计算额度；停止后保存的工作空间仍占存储额度。不要把待分析的商业软件、客户文件或凭据提交到公开仓库。

## 安装配置文件
- .devcontainer/devcontainer.json
- .devcontainer/setup.sh
- .devcontainer/verify.sh

云端证据位于 /tmp/rea-final-doctor.json、/tmp/rea-smoke.json、/tmp/rea-native-smoke.json、/tmp/rea-verify.log；/tmp 不是长期保存目录。
