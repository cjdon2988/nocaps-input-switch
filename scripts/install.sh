#!/bin/bash
# 把 Caps Lock 對應成 F18,登入時自動套用。
# 用法: install.sh [--dry-run]
set -euo pipefail

LABEL="com.nocaps.capslock-f18"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
MAPPING='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}'
DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

[ "$(uname)" = "Darwin" ] || { echo "只支援 macOS" >&2; exit 1; }
[ -x /usr/bin/hidutil ] || { echo "找不到 /usr/bin/hidutil" >&2; exit 1; }

write_plist() {
cat > "$1" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>$MAPPING</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
}

if [ "$DRY_RUN" = 1 ]; then
    tmp="$(mktemp)"
    write_plist "$tmp"
    plutil -lint "$tmp"
    echo "--- 會寫入 $PLIST ---"
    cat "$tmp"
    rm "$tmp"
    exit 0
fi

mkdir -p "$HOME/Library/LaunchAgents"
write_plist "$PLIST"
plutil -lint "$PLIST"

# 已載入過就先卸載,避免重複
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"

# 立刻套用,不必等下次登入
/usr/bin/hidutil property --set "$MAPPING" >/dev/null

if /usr/bin/hidutil property --get UserKeyMapping | grep -q 30064771181; then
    echo "完成:Caps Lock 已對應成 F18。"
    echo "下一步:到系統設定指定輸入方式快速鍵,見 README。"
else
    echo "已寫入,但驗證沒看到對應。請執行 hidutil property --get UserKeyMapping 檢查。" >&2
    exit 1
fi
