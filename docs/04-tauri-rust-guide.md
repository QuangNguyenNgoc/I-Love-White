# Hướng Dẫn Tauri + Rust (Step 2)

## 📖 Giới Thiệu

Tài liệu này chuẩn bị kiến thức cho **Step 2** - xây dựng frontend với React + Tauri + Rust.

> [!NOTE]
> Đây là tài liệu tham khảo cho tương lai. Step 1 (AHK) cần hoàn thành trước.

---

## 🎯 Tại Sao Chọn Tauri?

| Tiêu chí | Tauri | Electron |
|----------|-------|----------|
| **Kích thước** | ~5 MB | ~150 MB |
| **RAM** | Thấp | Cao |
| **Backend** | Rust | Node.js |
| **Render** | WebView2 | Chromium |
| **Security** | Cao | Trung bình |

---

## 🔧 Yêu Cầu Cài Đặt

### 1. Rust
```bash
# Windows - Download từ https://rustup.rs/
rustup-init.exe

# Verify
rustc --version
cargo --version
```

### 2. Node.js
```bash
# Download từ https://nodejs.org/
# Chọn LTS version

# Verify
node --version
npm --version
```

### 3. Tauri CLI
```bash
npm install -g @tauri-apps/cli
```

### 4. WebView2
- Windows 10/11 thường đã có sẵn
- Nếu không: https://developer.microsoft.com/en-us/microsoft-edge/webview2/

---

## 🚀 Tạo Dự Án Tauri

```bash
# Tạo project mới
npm create tauri-app@latest frontend

# Chọn options:
# - Package manager: npm
# - UI template: React
# - UI flavor: TypeScript

# Vào thư mục
cd frontend

# Cài dependencies
npm install

# Chạy dev mode
npm run tauri dev
```

---

## 📁 Cấu Trúc Tauri Project

```
frontend/
├── src/                    # React source
│   ├── App.tsx            # Main component
│   ├── main.tsx           # Entry point
│   └── components/        # UI components
│
├── src-tauri/             # Rust backend
│   ├── src/
│   │   └── main.rs        # Rust entry
│   ├── Cargo.toml         # Rust dependencies
│   └── tauri.conf.json    # Tauri config
│
└── package.json
```

---

## 🔗 Giao Tiếp Frontend ↔ Backend

### Invoke Command (React → Rust)

**Rust (src-tauri/src/main.rs)**:
```rust
#[tauri::command]
fn read_stats() -> String {
    let path = "../data/stats.json";
    std::fs::read_to_string(path).unwrap_or_default()
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![read_stats])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

**React (src/App.tsx)**:
```typescript
import { invoke } from '@tauri-apps/api/tauri';

async function loadStats() {
  const stats = await invoke<string>('read_stats');
  return JSON.parse(stats);
}
```

---

### File Watcher (Rust)

```rust
use notify::{Watcher, RecursiveMode, watcher};
use std::sync::mpsc::channel;
use std::time::Duration;

fn watch_stats_file() {
    let (tx, rx) = channel();
    let mut watcher = watcher(tx, Duration::from_secs(1)).unwrap();
    watcher.watch("../data/stats.json", RecursiveMode::NonRecursive).unwrap();

    loop {
        match rx.recv() {
            Ok(event) => println!("File changed: {:?}", event),
            Err(e) => println!("Watch error: {:?}", e),
        }
    }
}
```

---

## 📊 Charts với Recharts

### Cài đặt
```bash
npm install recharts
```

### Ví dụ
```tsx
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts';

const data = [
  { time: '10:00', honey: 100000 },
  { time: '10:05', honey: 125000 },
  { time: '10:10', honey: 180000 },
];

function HoneyChart() {
  return (
    <LineChart width={600} height={300} data={data}>
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="time" />
      <YAxis />
      <Tooltip />
      <Line type="monotone" dataKey="honey" stroke="#f0b90b" />
    </LineChart>
  );
}
```

---

## 🎨 UI Components Cần Thiết

| Component | Mô tả |
|-----------|-------|
| `StatCard` | Hiển thị số liệu đơn lẻ |
| `RateDisplay` | Hiển thị tốc độ +X/s |
| `TimeSeriesChart` | Đồ thị theo thời gian |
| `SessionInfo` | Thông tin session |
| `AlertList` | Danh sách cảnh báo |

---

## 📚 Tài Nguyên Học Thêm

### Rust
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)

### Tauri
- [Tauri Docs](https://tauri.app/v1/guides/)
- [Tauri + React Tutorial](https://tauri.app/v1/guides/getting-started/setup/vite)

### React
- [React Docs](https://react.dev/)
- [Recharts](https://recharts.org/)

---

## ✅ Checklist Step 2

- [ ] Hoàn thành Step 1 (AHK backend)
- [ ] Cài đặt Rust, Node.js, Tauri CLI
- [ ] Tạo Tauri project
- [ ] Implement file watcher
- [ ] Tạo dashboard UI
- [ ] Tạo charts
- [ ] Test integration với AHK
