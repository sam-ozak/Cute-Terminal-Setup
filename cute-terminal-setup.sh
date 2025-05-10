#!/bin/bash
set -e

echo "🚀 Welcome to Cute Terminal Setup!"

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script with sudo: sudo ./cute-terminal-setup.sh"
    exit 1
fi

# Get the username of the user who invoked sudo
USER_NAME=$(logname)
USER_HOME=$(eval echo "~$USER_NAME")

# Install required packages for SolusOS
echo "🔧 Installing required dependencies for SolusOS..."
sudo -u "$USER_NAME" eopkg install -y git curl wget unzip fontconfig x11-apps > /dev/null 2>&1

# Install Nerd Font (Fira Code Nerd Font)
echo "🔤 Installing Fira Code Nerd Font..."
FONT_DIR="$USER_HOME/.local/share/fonts"
sudo -u "$USER_NAME" mkdir -p "$FONT_DIR"
sudo -u "$USER_NAME" wget -q -O "$FONT_DIR/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
sudo -u "$USER_NAME" unzip -o "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR/FiraCode" > /dev/null 2>&1
sudo -u "$USER_NAME" rm -rf "$FONT_DIR/FiraCode.zip" "$FONT_DIR/FiraCode/*Windows*" "$FONT_DIR/FiraCode/*macOS*"
fc-cache -fv > /dev/null 2>&1

echo "📌 Please set your terminal font to 'Fira Code Nerd Font' for icons to display properly."

# Link Cutefetch to $HOME/.local/bin
echo "🔗 Linking Cutefetch to $USER_HOME/.local/bin..."
BIN_DIR="$USER_HOME/.local/bin"
sudo -u "$USER_NAME" mkdir -p "$BIN_DIR"
sudo -u "$USER_NAME" ln -sf "$PWD/Cutefetch" "$BIN_DIR/cutefetch"

# Fix permissions for Cutefetch
echo "🔒 Setting executable permissions for Cutefetch..."
sudo -u "$USER_NAME" chmod +x "$PWD/Cutefetch"
sudo -u "$USER_NAME" chmod +x "$BIN_DIR/cutefetch"

# Ensure $HOME/.local/bin is in PATH
if ! grep -q "$BIN_DIR" <<<"$PATH"; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$USER_HOME/.bashrc"
    echo "Added $BIN_DIR to PATH in .bashrc"
fi

echo "✅ Setup complete! Reload your shell or run 'exec \$SHELL' to apply changes."
