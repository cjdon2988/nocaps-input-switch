#!/bin/bash
# 還原:移除 LaunchAgent 並清除按鍵對應。
set -euo pipefail

LABEL="com.nocaps.capslock-f18"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
[ -f "$PLIST" ] && rm "$PLIST"
/usr/bin/hidutil property --set '{"UserKeyMapping":[]}' >/dev/null

echo "已還原:Caps Lock 恢復原本功能。"
echo "記得到系統設定把輸入方式快速鍵(F18)改回或取消。"
