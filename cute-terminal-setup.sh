#!/bin/bash
set -e

echo "🚀 Welcome to Cute Terminal Setup!"

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script with sudo: sudo ./cute-terminal-setup.sh"
    exit 1
fi

# Install required packages for SolusOS
echo "🔧 Installing required dependencies for SolusOS..."
sudo eopkg install -y git curl wget unzip fontconfig x11-apps > /dev/null 2>&1

# Install Nerd Font (Fira Code Nerd Font)
echo "🔤 Installing Fira Code Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
sudo -u "$SUDO_USER" mkdir -p "$FONT_DIR"
sudo -u "$SUDO_USER" wget -q -O "$FONT_DIR/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
sudo -u "$SUDO_USER" unzip -o "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR/FiraCode" > /dev/null 2>&1
sudo -u "$SUDO_USER" rm -rf "$FONT_DIR/FiraCode.zip" "$FONT_DIR/FiraCode/*Windows*" "$FONT_DIR/FiraCode/*macOS*"
fc-cache -fv > /dev/null 2>&1

echo "📌 Please set your terminal font to 'Fira Code Nerd Font' for icons to display properly."

# Link Cutefetch to $HOME/.local/bin
echo "🔗 Linking Cutefetch to $HOME/.local/bin..."
BIN_DIR="$HOME/.local/bin"
sudo -u "$SUDO_USER" mkdir -p "$BIN_DIR"
sudo -u "$SUDO_USER" ln -sf "$PWD/Cutefetch" "$BIN_DIR/cutefetch"

# Fix permissions for Cutefetch
echo "🔒 Setting correct permissions for Cutefetch..."
sudo -u "$SUDO_USER" chmod +x "$PWD/Cutefetch"
sudo -u "$SUDO_USER" chmod +x "$BIN_DIR/cutefetch"

# Ensure $HOME/.local/bin is in PATH
if ! sudo -u "$SUDO_USER" grep -q "$HOME/.local/bin" <<<"$PATH"; then
    echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"
    echo "Added $HOME/.local/bin to PATH in .bashrc"
fi

echo "✅ Setup complete! Reload your shell or run 'exec \$SHELL' to apply changes."
