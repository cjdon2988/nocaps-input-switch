---
name: nocaps-input-switch
description: 在 macOS 上把 Caps Lock 改成專職切換中英輸入法(對應成 F18,指定給輸入方式快速鍵),避免外接鍵盤(如藍牙 MX Keys)誤觸大寫。使用者說 Caps Lock 常誤觸、想用 Caps Lock 切換輸入法、想取消大寫鎖定時使用。
---

# nocaps-input-switch

用 macOS 內建的 `hidutil` 把 Caps Lock 對應成 F18,再把輸入方式快速鍵指定給 F18。不裝第三方軟體。

## 流程

1. 確認是 macOS(`uname` 為 Darwin)。其他系統不適用。
2. 向使用者說明會做什麼,取得同意後才安裝:
   - 在 `~/Library/LaunchAgents/` 新增 `com.nocaps.capslock-f18.plist`,登入時執行一行 `hidutil`。
   - 效果是 Caps Lock 不再鎖大寫。要大寫用 Shift。
3. 先執行 `scripts/install.sh --dry-run` 給使用者看內容,同意後執行 `scripts/install.sh`。
4. 用 `hidutil property --get UserKeyMapping` 驗證,應看到 Src 30064771129 與 Dst 30064771181。
5. 請使用者在系統設定自己指定快速鍵(這步不要用腳本改系統設定):
   - 系統設定 > 鍵盤 > 鍵盤快速鍵 > 輸入方式,勾選「選擇上一個輸入方式」,按 Caps Lock 錄製。
   - 系統設定 > 鍵盤 > 文字輸入 > 輸入方式 > 編輯,關閉「使用大寫鎖定鍵切換」。
6. 請使用者實際按 Caps Lock 測試切換。

## 還原

執行 `scripts/uninstall.sh`,再請使用者把輸入方式快速鍵改回或取消。

## 注意

- 不要刪除或改動使用者其他的 LaunchAgents。
- 設定只對目前登入使用者生效。共用電腦上不要動別人的帳號。
- 目前對所有鍵盤生效,包含內建鍵盤。
- 疑難排解見 `README.md`。
