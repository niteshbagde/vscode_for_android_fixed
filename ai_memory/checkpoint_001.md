# AI Memory & Checkpoints

## Project Mission
Build a native Android VS Code workstation APK for Xiaomi Pad 6 (Android 12/13/14+ / HyperOS), based on or extending the concepts from [VSCodroid](https://github.com/rmyndharis/VSCodroid) and the native code-server/Termux architecture with zero/minimal user interaction barriers.

## Checkpoint 001 - Initialization & Discovery
- **Timestamp**: 2026-10-15
- **Status**: Starting discovery and environment reconnaissance.
- **Reference Repository**: https://github.com/rmyndharis/VSCodroid
- **Target Device**: Xiaomi Pad 6 (ARM64-v8a, Android 13/14 / HyperOS)
- **Key Objectives**:
  1. Inspect VSCodroid codebase and its mechanisms (Termux bootstrap, proot, code-server, webview / native wrapper).
  2. Solve Android 12+ compatibility (phantom process killer, W^X exec restrictions in targetSdk >= 29, scoped storage bypass).
  3. Prepare automated packaging / compilation pipeline for building an installable `.apk` file.
  4. Ensure minimal user interaction is needed to boot up VS Code.
