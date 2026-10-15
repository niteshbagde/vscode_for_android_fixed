# AI Memory Checkpoint 003 - GitHub Synchronization & Repository Layout

- **Timestamp**: 2026-10-15
- **Status**: Codebase structured at root; git repository prepared for push to target remote.
- **Target Repository**: `https://github.com/niteshbagde/vscode_for_android_fixed.git`
- **Target Branch**: `main`

---

## 1. Structure Overview
- `android/`: Full Kotlin/Gradle Android application source, configured with legacy JNI packaging, WebView interface, and extra key row.
- `scripts/`: Toolchain, VS Code compilation, and verification scripts.
- `patches/`: All custom unified diff patches applied to upstream Code-OSS (worker thread PtyHost/ExtHost, socket bridges, reconnection shims).
- `branding/`: App assets and product configurations.
- `docs/`: Full architecture and user guide specifications.
- `setup.sh`: Automated unattended setup script for native ARM64 code-server deployment on Termux.
- `todo.md`: Project requirement tracking.
- `ai_memory/`: Persistent checkpoints recording system evolution and architecture state.
- `app-release.apk` & `toolchains/`: Excluded from git commits via `.gitignore` to strictly comply with GitHub's 100MB file limit. APK available locally for direct sideloading or release upload.

---

## 2. Remote Synchronization
- Initializing git repository at root.
- Adding remote `origin https://github.com/niteshbagde/vscode_for_android_fixed.git`.
- Fetching existing remote `main` branch (which contains initial `LICENSE`).
- Staging and committing all project files.
