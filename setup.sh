#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# 1. Safety & Error Handling / Non-interactive flags
export DEBIAN_FRONTEND=noninteractive
export DPKG_OPTIONS="-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"

# 2. Android Process Stability (Wake-lock)
if command -v termux-wake-lock >/dev/null 2>&1; then
    echo "[+] Acquiring Termux wake-lock to prevent OS kernel sleep..."
    termux-wake-lock || true
fi

# 3. Package Repositories & Dependencies
echo "[+] Updating and upgrading existing Termux packages..."
pkg update -y $DPKG_OPTIONS
pkg upgrade -y $DPKG_OPTIONS

echo "[+] Enabling and installing tur-repo (Termux User Repository)..."
if ! dpkg -s tur-repo >/dev/null 2>&1; then
    pkg install -y $DPKG_OPTIONS tur-repo
fi

echo "[+] Installing core build & runtime toolchain..."
pkg install -y $DPKG_OPTIONS \
    build-essential \
    git \
    python \
    nodejs-lts \
    termux-tools \
    code-server

# 4. Robust Configuration Injection (~/.config/code-server/config.yaml)
CONFIG_DIR="$HOME/.config/code-server"
CONFIG_FILE="$CONFIG_DIR/config.yaml"

mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
    cat << 'EOF' > "$CONFIG_FILE"
bind-addr: 127.0.0.1:8080
auth: none
cert: false
EOF
else
    # Update or insert keys idempotently using python
    python - << 'PYEOF'
import os

path = os.path.expanduser("~/.config/code-server/config.yaml")
keys = {
    "bind-addr": "127.0.0.1:8080",
    "auth": "none",
    "cert": "false"
}

lines = []
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()

found = set()
new_lines = []

for line in lines:
    stripped = line.strip()
    updated = False
    for k, v in keys.items():
        if stripped.startswith(f"{k}:"):
            new_lines.append(f"{k}: {v}\n")
            found.add(k)
            updated = True
            break
    if not updated:
        new_lines.append(line)

for k, v in keys.items():
    if k not in found:
        new_lines.append(f"{k}: {v}\n")

with open(path, "w", encoding="utf-8") as f:
    f.writelines(new_lines)
PYEOF
fi

# 5. Shell Persistence (~/.bashrc)
BASHRC="$HOME/.bashrc"
touch "$BASHRC"

ALIAS_CMD='alias startcode="termux-wake-lock && code-server --disable-telemetry"'
if ! grep -q "alias startcode=" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# Code-Server shortcut" >> "$BASHRC"
    echo "$ALIAS_CMD" >> "$BASHRC"
fi

# Gather installed versions
NODE_VER=$(node -v 2>/dev/null || echo "Unknown")
CODE_VER=$(code-server --version 2>/dev/null | head -n 1 || echo "Installed")

# 6. Status & Handoff
clear

echo -e "\033[1;36m====================================================================\033[0m"
echo -e "\033[1;32m      NATIVE ANDROID VS CODE WORKSTATION (CODE-SERVER) READY!      \033[0m"
echo -e "\033[1;36m====================================================================\033[0m"
echo -e "\033[1;33m[*] Environment Specs:\033[0m"
echo -e "    - Node Version       : \033[1;37m$NODE_VER\033[0m"
echo -e "    - Code-Server Version: \033[1;37m$CODE_VER\033[0m"
echo -e "    - Bind Address       : \033[1;32mhttp://127.0.0.1:8080\033[0m"
echo -e "    - Authentication     : \033[1;37mnone\033[0m"
echo ""
echo -e "\033[1;33m[*] Launch Shortcut:\033[0m"
echo -e "    Type \033[1;32mstartcode\033[0m and press Enter in Termux."
echo ""
echo -e "\033[1;33m[*] Android 12+ Background Stability (HyperOS / MIUI):\033[0m"
echo -e "    1. App Info -> Battery Saver -> Set to 'No restrictions'."
echo -e "    2. App Info -> Enable 'Autostart'."
echo -e "    3. Lock Termux in the Recents tray (Pad/Tablet task switcher)."
echo -e "    4. If Phantom Process Killer triggers, disable it via ADB:"
echo -e "       \033[1;35madb shell \"/system/bin/device_config put activity_manager max_phantom_processes 2147483647\"\033[0m"
echo -e "\033[1;36m====================================================================\033[0m"
