# White Macro BSS

Công cụ **theo dõi và thu thập thống kê** cho game Bee Swarm Simulator (Roblox), sử dụng AutoHotkey v2 với GDI+ image tracking.

## 🎯 Tính năng

- **Stat Tracking**: Theo dõi Honey, Pollen, resources
- **Rate Calculator**: Tính tốc độ tăng/giây
- **Screenshot**: Chụp màn hình game
- **Data Export**: Xuất dữ liệu JSON

## 🚀 Bắt đầu

### Yêu cầu
- Windows 10/11
- [AutoHotkey v2](https://www.autohotkey.com/)
- Roblox + Bee Swarm Simulator

### Cài đặt

```bash
# Cài AutoHotkey v2 từ website
# https://www.autohotkey.com/

# Chạy macro
START.bat
```

## ⌨️ Phím tắt

| Phím | Chức năng |
|------|-----------|
| `F1` | Start/Stop tracking |
| `F2` | Chụp screenshot |
| `ESC` | Thoát |

## 📁 Cấu trúc

```
├── src/          # Mã nguồn AHK
├── lib/          # Thư viện (GDI+, JSON)
├── assets/       # Hình ảnh tracking
├── data/         # Config, logs, stats
└── docs/         # Tài liệu
```

## 📚 Tài liệu

- [Tổng quan dự án](docs/00-project-overview.md)
- [Hướng dẫn AHK](docs/01-ahk-basics.md)
- [Kiến trúc](docs/02-project-architecture.md)
- [Nghiên cứu Natro](docs/03-natro-macro-research.md)

## 📝 License

MIT
