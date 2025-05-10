#!/bin/bash
set -e

echo "🚀 Welcome to Cute Terminal Setup!"

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script with sudo: sudo ./cute-terminal-setup.sh"
    exit 1
fi

# Detect the shell and configuration file
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""
case "$SHELL_NAME" in
    bash)
        CONFIG_FILE="$HOME/.bashrc"
        ;;
    zsh)
        CONFIG_FILE="$HOME/.zshrc"
        ;;
    *)
        echo "⚠️ Unsupported shell: $SHELL_NAME. Only bash or zsh are supported."
        exit 1
        ;;
esac
echo "🐚 Detected shell: $SHELL_NAME"

# Clone or refresh the repository
REPO_URL="https://github.com/sam-ozak/Cute-Terminal-Setup.git"
CUTE_DIR="$HOME/Cute-Terminal-Setup"

if [ -d "$CUTE_DIR" ]; then
    echo "🗑️ Removing existing repo directory..."
    rm -rf "$CUTE_DIR"
fi

echo "🔁 Cloning the repository from GitHub..."
git clone "$REPO_URL" "$CUTE_DIR"

chmod +x "$CUTE_DIR/cutefetch"

# Add to PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$CUTE_DIR/cutefetch" "$HOME/.local/bin/cutefetch" > /dev/null 2>&1
export PATH="$HOME/.local/bin:$PATH"

# Install dependencies based on detected package manager
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
    sudo eopkg install -y git curl wget unzip fontconfig x11-apps > /dev/null 2>&1
elif command -v xbps-install &> /dev/null; then
    echo "🔧 Detected Void Linux. Installing dependencies..."
    sudo xbps-install -Sy --noconfirm git curl wget unzip fontconfig xorg-xdpyinfo > /dev/null 2>&1
elif command -v zypper &> /dev/null; then
    echo "🔧 Detected openSUSE. Installing dependencies..."
    sudo zypper --non-interactive install git curl wget unzip fontconfig xorg-xdpyinfo > /dev/null 2>&1
else
    echo "⚠️ Unsupported package manager. Please install the required packages manually: git, curl, wget, unzip, fontconfig, x11-apps"
    exit 1
fi

# Set up fonts
echo "🔤 Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip -o FiraCode.zip -d FiraCode > /dev/null 2>&1
rm -rf FiraCode.zip FiraCode/*Windows* FiraCode/*macOS*
fc-cache -fv > /dev/null 2>&1

# Install Starship if not already installed
STARSHIP_BIN="$HOME/.local/bin/starship"
if [ ! -f "$STARSHIP_BIN" ]; then
    echo "📥 Installing Starship..."
    mkdir -p "$(dirname "$STARSHIP_BIN")"
    curl -sS https://starship.rs/install.sh | sh -s -- -y > /dev/null 2>&1
fi

# Apply Starship configuration
STARSHIP_CONFIG="$HOME/.config/starship.toml"
if [ -f "$CUTE_DIR/starship.toml" ]; then
    mkdir -p "$(dirname "$STARSHIP_CONFIG")"
    cp "$CUTE_DIR/starship.toml" "$STARSHIP_CONFIG"
    echo "🔧 Applied Starship configuration"
else
    echo "⚠️ No starship.toml found in the repository"
fi

# Backup and update the shell configuration file
if [ -f "$CONFIG_FILE" ]; then
    echo "💾 Backing up $CONFIG_FILE to ${CONFIG_FILE}.bak"
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
fi

echo "🔧 Updating $CONFIG_FILE..."
cat >> "$CONFIG_FILE" << 'EOF'

# >>> Cute Terminal Setup >>>
export PATH="$HOME/.local/bin:$PATH"

# Set Fira Code Nerd Font if GUI is available
if [[ "$TERM" != "linux" ]]; then
    export FONT="FiraCode Nerd Font"
fi

# Run cute fetch at startup (only if not SSH/tty)
if [[ "$TERM" != "linux" && "$SSH_TTY" == "" ]]; then
    cutefetch -r
fi

# Load Starship prompt
eval "$(starship init $SHELL_NAME)"
# <<< Cute Terminal Setup <<<
EOF

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📌 Final steps:"
echo "1. Set your terminal font to 'FiraCode Nerd Font'."
echo "2. Restart your shell or run: exec $SHELL_NAME"
