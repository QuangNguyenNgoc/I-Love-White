# Kiến Trúc Dự Án White Macro BSS

## 📁 Cấu Trúc Chi Tiết

```
ahk-White-macro-bss/
│
├── 📁 src/                         # Mã nguồn AHK chính
│   ├── main.ahk                   # Entry point
│   ├── gui.ahk                    # Windows GUI
│   │
│   ├── 📁 core/                   # Logic cốt lõi
│   │   ├── image-tracker.ahk      # Wrapper cho GDI+ image search
│   │   ├── screen-capture.ahk     # Chụp màn hình
│   │   └── state-manager.ahk      # Quản lý trạng thái
│   │
│   ├── 📁 modules/                # Các module tính năng
│   │   ├── stat-collector.ahk     # Thu thập thống kê
│   │   ├── rate-calculator.ahk    # Tính tốc độ tăng
│   │   ├── skill-monitor.ahk      # Theo dõi kỹ năng
│   │   ├── alert-system.ahk       # Hệ thống cảnh báo
│   │   └── auto-keys.ahk          # Tự động bấm phím
│   │
│   └── 📁 utils/                  # Tiện ích
│       ├── logger.ahk             # Ghi log
│       ├── config.ahk             # Quản lý cấu hình
│       └── data-exporter.ahk      # Xuất dữ liệu JSON
│
├── 📁 lib/                         # Thư viện bên ngoài
│   ├── Gdip_All.ahk               # GDI+ wrapper (từ Natro)
│   ├── Gdip_ImageSearch.ahk       # Image search (từ Natro)
│   ├── JSON.ahk                   # JSON parser
│   ├── Roblox.ahk                 # Roblox utilities
│   └── HyperSleep.ahk             # High-precision sleep
│
├── 📁 assets/                      # Tài nguyên
│   ├── 📁 images/                 # Hình ảnh tracking
│   │   ├── currency/              # Icons tiền, tài nguyên
│   │   ├── skills/                # Icons kỹ năng
│   │   ├── items/                 # Icons vật phẩm
│   │   └── ui/                    # UI elements
│   │
│   ├── 📁 paths/                  # [Tương lai] Đường đi
│   └── 📁 patterns/               # [Tương lai] Mẫu di chuyển
│
├── 📁 data/                        # Dữ liệu runtime
│   ├── config.json                # Cấu hình người dùng
│   ├── stats.json                 # Thống kê thu thập
│   └── 📁 logs/                   # Log files
│
├── 📁 docs/                        # Tài liệu
│
├── 📁 frontend/                    # [Step 2] React + Tauri
│   ├── 📁 src/                    # React source
│   ├── 📁 src-tauri/              # Rust backend
│   └── package.json
│
├── START.bat                       # Khởi động macro
└── .gitignore
```

---

## 🔄 Data Flow

```mermaid
flowchart LR
    subgraph Input
        A[Roblox Screen]
    end
    
    subgraph Processing
        B[screen-capture.ahk]
        C[image-tracker.ahk]
        D[stat-collector.ahk]
        E[rate-calculator.ahk]
    end
    
    subgraph Output
        F[(stats.json)]
        G[GUI Display]
        H[Alert]
    end
    
    A -->|GDI+ Capture| B
    B -->|Bitmap| C
    C -->|Found Values| D
    D -->|Raw Stats| E
    E -->|Calculated Rates| F
    E --> G
    D -->|Threshold Check| H
```

---

## 🧩 Module Descriptions

### Core

| Module | Trách nhiệm |
|--------|-------------|
| `image-tracker.ahk` | Wrapper đơn giản cho Gdip_ImageSearch, cache bitmap |
| `screen-capture.ahk` | Chụp vùng cụ thể của Roblox window |
| `state-manager.ahk` | Lưu trạng thái game, previous values |

### Modules

| Module | Trách nhiệm |
|--------|-------------|
| `stat-collector.ahk` | Thu thập Honey, Pollen, tickets... |
| `rate-calculator.ahk` | Tính ΔValue/Δt (per second, minute) |
| `skill-monitor.ahk` | Detect kỹ năng đang active |
| `alert-system.ahk` | Cảnh báo âm thanh/visual |
| `auto-keys.ahk` | Gửi phím 1-9, `<` `>` |

### Utils

| Module | Trách nhiệm |
|--------|-------------|
| `logger.ahk` | Ghi log theo level (debug, info, warn, error) |
| `config.ahk` | Load/save config.json |
| `data-exporter.ahk` | Xuất stats.json cho frontend |

---

## 🔗 Giao Tiếp AHK ↔ Tauri (Step 2)

### Phương án đề xuất: **File JSON + File Watcher**

```mermaid
sequenceDiagram
    participant A as AHK Backend
    participant F as stats.json
    participant R as Rust (Tauri)
    participant U as React UI
    
    loop Every 1s
        A->>F: Write stats
    end
    
    R->>F: Watch file changes
    F-->>R: File modified
    R->>R: Parse JSON
    R->>U: Update state
    U->>U: Re-render charts
```

**Ưu điểm:**
- Đơn giản, không cần socket/HTTP
- Dễ debug (xem file trực tiếp)
- AHK và Tauri hoàn toàn độc lập

**File format:**
```json
{
  "timestamp": 1702296847,
  "session": {
    "startTime": 1702293247,
    "duration": 3600
  },
  "stats": {
    "honey": 1500000,
    "honeyRate": 250.5,
    "pollen": 45000,
    "pollenRate": 75.2
  },
  "skills": {
    "active": ["Bear Morph", "Coconut"],
    "cooldowns": {}
  },
  "alerts": []
}
```

---

## 🚀 Execution Flow

```mermaid
stateDiagram-v2
    [*] --> Init: START.bat
    Init --> LoadConfig: Load config.json
    LoadConfig --> InitGDI: Gdip_Startup()
    InitGDI --> LoadAssets: Load bitmap assets
    LoadAssets --> MainLoop: Ready
    
    MainLoop --> Capture: Every 100ms
    Capture --> Analyze: Image Search
    Analyze --> UpdateStats: Found values
    UpdateStats --> CheckAlerts: Compare thresholds
    CheckAlerts --> AutoKeys: Send if needed
    AutoKeys --> ExportData: Write JSON
    ExportData --> UpdateGUI: Refresh display
    UpdateGUI --> MainLoop: Continue
    
    MainLoop --> Cleanup: User Stop
    Cleanup --> [*]: Gdip_Shutdown()
```

---

## Tiếp Theo

- [03 - Nghiên cứu Natro Macro](./03-natro-macro-research.md)
- [04 - Hướng dẫn Tauri/Rust](./04-tauri-rust-guide.md)
