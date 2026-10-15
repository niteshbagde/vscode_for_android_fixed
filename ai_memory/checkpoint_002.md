# AI Memory Checkpoint 002 - Build & Verification Complete

- **Timestamp**: 2026-10-15
- **Status**: Ready for Deployment & Testing on Xiaomi Pad 6
- **Device Target**: Xiaomi Pad 6 (Snapdragon 870, arm64-v8a, Android 13/14 / Xiaomi HyperOS / MIUI 14)

---

## 1. Deliverables Prepared in Workspace
1. **`app-release.apk`** (206.1 MB):
   - Package: `com.vscodroid` (v1.5.0, build 16)
   - Architecture: Native `arm64-v8a` (matches Snapdragon 870 perfectly)
   - Min SDK: 30 (Android 11+)
   - Target SDK: 36 (Android 15+ compatible)
   - Permissions: Zero invasive permissions required (no `MANAGE_EXTERNAL_STORAGE` or `READ_EXTERNAL_STORAGE`). Only standard `INTERNET` and `FOREGROUND_SERVICE`.
   - Integrity: SHA256 verified against official release manifest:
     `B0C3C5F35A08F57FFCAF7D056885153AA263B2013279C93E7A1456DB9EF9E4C0`
2. **`setup.sh`**:
   - Automated, idempotent, unattended bash script complying with the specification in `todo.md` for native Termux code-server deployment on ARM64.
3. **`toolchains/`**:
   - `toolchain_cpp.zip` (70.3 MB): Clang/LLVM C/C++ offline toolchain.
   - `toolchain_java.zip` (53.6 MB): OpenJDK 17 headless runtime.
   - `toolchain_ruby.zip` (10.0 MB): Ruby runtime.

---

## 2. Technical Architecture & Android 12+ Optimization
- **W^X Execution**: Executables are packaged as `.so` files in `jniLibs/arm64-v8a` and extracted by Android Package Manager with execution bits, bypassing the Android 10+ W^X ban on private app storage execution.
- **Phantom Process Killer Immunity**:
  - VS Code Extension Host and Pty Host run inside worker threads instead of separate spawned processes, staying well within the Android 12+ 32 phantom process cap.
- **Foreground Service**:
  - Registered with `specialUse` / `dataSync` service types, preventing MIUI / HyperOS aggressive battery management from terminating the background server.
- **Loopback & Scoped Storage**:
  - All workspace and IDE operations stay inside internal loopback (`http://127.0.0.1:<PORT>`) and the app's sandboxed `filesDir/workspace`, eliminating Scoped Storage permission barriers and slow SAF overhead.

---

## 3. Xiaomi Pad 6 Specific Configuration
- **HyperOS / MIUI Battery Saver**: Set to "No restrictions".
- **Autostart**: Enabled in App Info.
- **Stylus & Physical Keyboard**: Extra key row integrated into bottom bar; full support for Xiaomi Smart Pen, hardware Bluetooth/Pogo-pin keyboards (Ctrl, Alt, Tab, Esc shortcuts).
