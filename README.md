# nocaps-input-switch

把 MacBook 外接鍵盤(例如 Logitech MX Keys,藍牙連線)的 Caps Lock 改成專職切換中英輸入法,再也不會誤觸大寫。要大寫照舊用 Shift+字母或自動大寫。

只用 macOS 內建的 `hidutil` 與系統設定,不需要安裝第三方軟體,也不需要額外權限。

## 適合誰

- 打中文(注音、拼音等)又常打英文,Caps Lock 常常誤觸。
- 很少需要全大寫。
- 鍵盤用藍牙或接收器連 Mac 都可以,這個設定跟連線方式無關,內建鍵盤也一起套用。

## 原理

1. 用 `hidutil` 把 Caps Lock 對應成 F18。F18 不會鎖大寫,也不會有長按延遲。
2. 在系統設定把「選擇上一個輸入方式」指定給 F18。
3. 用一個 LaunchAgent 讓第 1 步每次登入自動套用(`hidutil` 的設定重開機會消失)。

## 安裝

```bash
git clone https://github.com/cjdon2988/nocaps-input-switch.git
cd nocaps-input-switch
./scripts/install.sh --dry-run   # 先看會寫入什麼
./scripts/install.sh
```

`install.sh` 只做兩件事:在 `~/Library/LaunchAgents/` 寫一個 plist,內容就是一行 `hidutil` 指令,然後載入它。

### 然後到系統設定(手動,約 30 秒)

1. 系統設定 > 鍵盤 > 鍵盤快速鍵 > 輸入方式。
2. 勾選「選擇上一個輸入方式」,點右邊的快速鍵欄位,按一下 Caps Lock。它會被錄成 F18。
3. 系統設定 > 鍵盤 > 文字輸入 > 輸入方式 > 編輯,把「使用大寫鎖定鍵切換『ABC』」關掉,避免兩套機制打架。

只有兩個輸入方式(例如 ABC 加注音)時,「上一個」就是單純的中英切換。

## 驗證

```bash
hidutil property --get UserKeyMapping
```

輸出裡看到 `HIDKeyboardModifierMappingSrc = 30064771129` 與 `HIDKeyboardModifierMappingDst = 30064771181`,就代表 Caps Lock 已對應成 F18。

## 還原

```bash
./scripts/uninstall.sh
```

再到系統設定把輸入方式快速鍵改回或取消。

## 常見問題

- **快速鍵欄位錄不到 F18,錄成一個鎖定符號**:對應沒生效,先跑驗證指令。沒有輸出就重新執行 `install.sh`。
- **重開機後失效**:執行 `launchctl kickstart -k gui/$(id -u)/com.nocaps.capslock-f18`,若仍無效重新登入。
- **只想改外接鍵盤,不想改內建鍵盤**:目前版本對所有鍵盤生效,尚未支援依型號篩選。
- **我偶爾真的需要鎖定大寫**:這個設定會完全取消 Caps Lock 的鎖定功能。要大寫請用 Shift。

## 它會動到什麼

- 新增一個檔案:`~/Library/LaunchAgents/com.nocaps.capslock-f18.plist`。
- 改變目前登入使用者的按鍵對應(只有 Caps Lock 一個鍵)。
- 不會動其他使用者的設定,不連網,不裝常駐程式。

## 授權

MIT。見 `LICENSE`。
