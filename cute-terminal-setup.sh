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

# Install Fira Code Nerd Font
echo "🔤 Installing Fira Code Nerd Font..."
FONT_DIR="$HOME/.fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip -o FiraCode.zip -d FiraCode > /dev/null 2>&1
rm -rf FiraCode.zip FiraCode/*Windows* FiraCode/*macOS*
fc-cache -fv > /dev/null 2>&1

echo "📌 Please set your terminal font to 'Fira Code Nerd Font' for icons to display properly."
