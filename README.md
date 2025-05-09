# Cute Terminal Setup 🐱🐧🐰

A portable terminal customization setup that brings **cute sysinfo**, **custom icons**, and **Starship prompt** to any Linux system!

This is a modified version of [elenapan](https://github.com/elenapan )'s `cutefetch`, maintained by [strafe](https://github.com/strafe ), and improved by [cybardev](https://github.com/cybardev ).

I've customized it further with:
- Battery percentage + remaining time (only when discharging)
- Uptime instead of resolution
- Symbolic icons (`♥`, ``, ``, `⏱`, ``)
- Auto-run at startup
- Starship integration

All packed into a single self-contained script — no need for extra files or internet!

---

## 📦 Features

- Fully works offline
- No extra config needed
- Works on **any Linux distro**: Ubuntu, Arch, Fedora, Debian, etc.
- Sets up your exact terminal look every time

---

## ⚙️ How It Works

When you run the installer:

1. Installs required packages (`git`, `curl`, `fontconfig`, etc.)
2. Downloads and sets up **FiraCode Nerd Font**
3. Embeds and installs your custom `cutefetch`
4. Installs and configures **Starship**
5. Updates `.bashrc` or `.zshrc` to auto-show cute fetch + starship

---

## 🛠️ Installation

### On Any Linux System

git clone https://github.com/sam-ozak/Cute-Terminal-Setup.git

cd Cute-Terminal-Setup

chmod +x cute-terminal-setup.sh

sudo ./cute-terminal-setup.sh

exec $SHELL
