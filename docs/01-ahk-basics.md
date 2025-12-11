# Hướng Dẫn Học AutoHotkey v2

## 🎯 Mục Tiêu

Học cơ bản AutoHotkey v2 để hiểu và phát triển White Macro BSS.

---

## 1. Cài Đặt

### Download
- **Website**: https://www.autohotkey.com/
- **Chọn**: AutoHotkey v2 (KHÔNG phải v1.1)

### VS Code Extension
- Cài **AutoHotkey v2 Language Support** từ Extensions

---

## 2. Cú Pháp Cơ Bản

### Hello World

```autohotkey
; File: hello.ahk
MsgBox "Hello, World!"
```

### Biến

```autohotkey
; Khai báo biến (không cần từ khóa)
myVar := "Hello"
myNumber := 42
myFloat := 3.14

; Hiển thị
MsgBox myVar " - Number: " myNumber
```

### Hàm

```autohotkey
; Định nghĩa hàm
Add(a, b) {
    return a + b
}

; Gọi hàm
result := Add(5, 3)
MsgBox "5 + 3 = " result
```

### Điều Kiện

```autohotkey
x := 10

if (x > 5) {
    MsgBox "x lớn hơn 5"
} else if (x = 5) {
    MsgBox "x bằng 5"
} else {
    MsgBox "x nhỏ hơn 5"
}
```

### Vòng Lặp

```autohotkey
; Loop cơ bản
Loop 5 {
    MsgBox "Lần " A_Index
}

; While loop
count := 0
while (count < 3) {
    MsgBox "Count: " count
    count++
}

; For loop với mảng
fruits := ["Apple", "Banana", "Orange"]
for index, fruit in fruits {
    MsgBox index ": " fruit
}
```

---

## 3. Hotkeys & Hotstrings

### Hotkeys (Phím Tắt)

```autohotkey
; Ctrl+J để hiện MsgBox
^j::MsgBox "Bạn bấm Ctrl+J"

; Win+N để mở Notepad
#n::Run "notepad.exe"

; F1 để tạm dừng script
F1::Pause
```

**Ký hiệu modifier:**
| Ký hiệu | Phím |
|---------|------|
| `^` | Ctrl |
| `!` | Alt |
| `+` | Shift |
| `#` | Win |

### Hotstrings

```autohotkey
; Gõ "btw" tự động thành "by the way"
::btw::by the way

; Gõ "@@" thành email
::@@::myemail@example.com
```

---

## 4. Làm Việc Với Cửa Sổ

### Lấy Thông Tin Cửa Sổ

```autohotkey
; Lấy title cửa sổ đang active
title := WinGetTitle("A")
MsgBox "Active window: " title

; Lấy handle (HWND)
hwnd := WinExist("Roblox")

; Lấy vị trí và kích thước
WinGetPos(&x, &y, &width, &height, "Roblox")
MsgBox "Position: " x "," y " Size: " width "x" height
```

### Điều Khiển Cửa Sổ

```autohotkey
; Activate cửa sổ
WinActivate "Roblox"

; Move cửa sổ
WinMove 0, 0, 800, 600, "Roblox"

; Minimize/Maximize
WinMinimize "Roblox"
WinMaximize "Roblox"
```

---

## 5. Mouse & Keyboard

### Mouse

```autohotkey
; Di chuyển chuột
MouseMove 100, 200

; Click
Click 100, 200        ; Click trái
Click 100, 200, "R"   ; Click phải

; Kéo thả
MouseClickDrag "L", 0, 0, 100, 100
```

### Keyboard

```autohotkey
; Gửi phím
Send "Hello World"
Send "{Enter}"
Send "^c"  ; Ctrl+C

; Gửi phím số
Send "{1}"  ; Phím 1
Send "{F1}" ; Phím F1
```

---

## 6. Include & Thư Viện

```autohotkey
; Include file khác
#Include "lib\Gdip_All.ahk"
#Include "lib\JSON.ahk"

; Include thư mục
#Include "lib\"
```

---

## 7. GDI+ Cơ Bản (Image Tracking)

```autohotkey
#Include "lib\Gdip_All.ahk"
#Include "lib\Gdip_ImageSearch.ahk"

; Khởi tạo GDI+
pToken := Gdip_Startup()

; Chụp màn hình
pBMScreen := Gdip_BitmapFromScreen("0|0|1920|1080")

; Load hình cần tìm
pBMNeedle := Gdip_CreateBitmapFromFile("image.png")

; Tìm kiếm
if (Gdip_ImageSearch(pBMScreen, pBMNeedle, &pos) = 1) {
    ; Tìm thấy tại pos = "x,y"
    coords := StrSplit(pos, ",")
    x := coords[1]
    y := coords[2]
    MsgBox "Found at: " x ", " y
}

; Giải phóng bộ nhớ
Gdip_DisposeImage(pBMScreen)
Gdip_DisposeImage(pBMNeedle)

; Kết thúc GDI+
Gdip_Shutdown(pToken)
```

---

## 8. Ví Dụ Hoàn Chỉnh

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force

; Hotkey để tracking
F2::{
    pToken := Gdip_Startup()
    
    ; Chụp màn hình Roblox
    if WinExist("Roblox") {
        WinGetPos(&x, &y, &w, &h, "Roblox")
        pBM := Gdip_BitmapFromScreen(x "|" y "|" w "|" h)
        
        ; Save screenshot
        Gdip_SaveBitmapToFile(pBM, "screenshot.png")
        MsgBox "Saved screenshot!"
        
        Gdip_DisposeImage(pBM)
    } else {
        MsgBox "Roblox not found!"
    }
    
    Gdip_Shutdown(pToken)
}

; ESC để thoát
Esc::ExitApp
```

---

## 📚 Tài Nguyên Học Thêm

1. **Official Docs**: https://www.autohotkey.com/docs/v2/
2. **Tutorial**: https://www.autohotkey.com/docs/v2/Tutorial.htm
3. **Forum**: https://www.autohotkey.com/boards/

---

## Tiếp Theo

- [02 - Kiến trúc dự án](./02-project-architecture.md)
- [03 - Nghiên cứu Natro Macro](./03-natro-macro-research.md)
