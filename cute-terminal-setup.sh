#!/bin/bash
set -e

echo "🚀 Welcome to Cute Terminal Setup!"

# Check for sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run with sudo: sudo ./cute-terminal-setup.sh"
    exit 1
fi

# Detect Shell
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""
if [[ "$SHELL_NAME" == "bash" ]]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [[ "$SHELL_NAME" == "zsh" ]]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo "⚠️ Unsupported shell: $SHELL_NAME. Only bash/zsh supported."
    exit 1
fi
echo "🐚 Detected shell: $SHELL_NAME"

# Clone repo
REPO_URL="https://github.com/sam-ozak/Cute-Terminal-Setup.git "
CUTE_DIR="$HOME/Cute-Terminal-Setup"

if [ -d "$CUTE_DIR" ]; then
    echo "🗑️ Removing old repo..."
    rm -rf "$CUTE_DIR"
fi

echo "🔁 Cloning your repo from GitHub..."
git clone "$REPO_URL" "$CUTE_DIR"

chmod +x "$CUTE_DIR/cutefetch"

# Add to PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$CUTE_DIR/cutefetch" "$HOME/.local/bin/cutefetch" > /dev/null 2>&1 || true
export PATH="$HOME/.local/bin:$PATH"

# Install dependencies based on distro
echo "📦 Installing required packages..."

if command -v apt-get &> /dev/null; then
    sudo apt update -y > /dev/null 2>&1
    sudo apt install -y git curl wget unzip fontconfig x11-apps > /dev/null 2>&1

elif command -v dnf &> /dev/null; then
    sudo dnf install -y git curl wget unzip fontconfig xorg-xdpyinfo > /dev/null 2>&1

elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm git curl wget unzip fontconfig xorg-server xorg-apps > /dev/null 2>&1

elif command -v eopkg &> /dev/null; then
    echo "🔧 Detected SolusOS. Installing dependencies..."
    sudo eopkg install -y git curl wget unzip fontconfig x11-apps

elif command -v xbps-install &> /dev/null; then
    echo "🔧 Detected Void Linux. Installing dependencies..."
    sudo xbps-install -Sy --noconfirm git curl wget unzip fontconfig xorg-xdpyinfo

elif command -v zypper &> /dev/null; then
    echo "🔧 Detected openSUSE. Installing dependencies..."
    sudo zypper --non-interactive install git curl wget unzip fontconfig xorg-xdpyinfo

else
    echo "⚠️ Could not detect distro. Assuming minimal setup..."
fi

# Set up fonts
echo "🔤 Installing FiraCode Nerd Font..."
mkdir -p "$HOME/.fonts"
cd "$HOME/.fonts"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip 
unzip -o FiraCode.zip -d FiraCode > /dev/null 2>&1
rm -rf FiraCode.zip FiraCode/*Windows* FiraCode/*macOS*
fc-cache -fv > /dev/null 2>&1

# Install Starship if missing
STARSHIP="$HOME/.local/bin/starship"
if [ ! -f "$STARSHIP" ]; then
    echo "📥 Installing Starship..."
    mkdir -p "$(dirname "$STARSHIP")"
    curl -sS https://starship.rs/install.sh  | sh -s -- -y > /dev/null 2>&1
fi

# Apply Starship config
STARSHIP_CONFIG="$HOME/.config/starship.toml"
if [ -f "$CUTE_DIR/starship.toml" ]; then
    mkdir -p "$(dirname "$STARSHIP_CONFIG")"
    cp "$CUTE_DIR/starship.toml" "$STARSHIP_CONFIG"
    echo "🔧 Starship config applied"
else
    echo "⚠️ No starship.toml found in repo"
fi

# Backup and Update Shell RC File
if [ -f "$CONFIG_FILE" ]; then
    echo "💾 Backing up $CONFIG_FILE to ${CONFIG_FILE}.bak"
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
fi

echo "🔧 Updating $CONFIG_FILE..."
cat >> "$CONFIG_FILE" << 'EOF'

# >>> Custom Terminal Setup >>>
export PATH="$HOME/.local/bin:$PATH"

# Set Fira Code Nerd Font if GUI available
if [[ "$TERM" != "linux" ]]; then
    export FONT="FiraCode Nerd Font"
fi

# Run cute fetch at startup (only if not SSH/tty)
if [[ "$TERM" != "linux" && "$SSH_TTY" == "" ]]; then
    cutefetch -r
fi

# Load starship
eval "$(starship init $SHELL_NAME)"
# <<< Custom Terminal Setup <<<
EOF

# Done!
echo ""
echo "🎉 All done!"
echo ""
echo "📌 To finish:"
echo "1. Set your terminal font to 'FiraCode Nerd Font'"
echo "2. Restart your shell or run: exec $SHELL_NAME"
