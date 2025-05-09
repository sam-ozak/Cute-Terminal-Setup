#!/bin/bash
set -e

# ██████╗ ██╗   ██╗██╗ ██████╗     ██████╗  █████╗ ███╗   ███╗
# ██╔══██╗██║   ██║██║ ██╔══██╗    ██╔══██╗██╔══██╗████╗ ████║
# ██████╔╝██║   ██║██║ ██████╔╝    ██████╔╝███████║██╔████╔██║
# ██╔══██╗██║   ██║██║ ██╔══██╗    ██╔══██╗██╔══██║██║╚██╔╝██║
# ██████╔╝╚██████╔╝██║ ██████╔╝    ██████╔╝██║  ██║██║ ╚═╝ ██║
# ╚═════╝  ╚═════╝ ╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝

echo "🚀 Welcome to Cute Terminal Setup!"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run with sudo: sudo ./cute-terminal-setup.sh"
  exit 1
fi

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

# ----------------------
# Functions to write embedded files
# ----------------------

write_cutefetch() {
cat > "$1" << 'EOF'
#!/usr/bin/env bash
# ------------------------------------------------------------------- #
#
# Tiny coloured fetch script with cute little animals
# Authored by: elenapan, strafe, cybardev
# Modified by YOU 💖
# ------------------------------------------------------------------- #

readonly VERSION_INFO="v3.0.0"

# ---------------------------- Utilities ---------------------------- #

help_info() {
    echo "Cutefetch - Tiny coloured fetch script to display sysinfo"
    echo ""
    echo "USAGE: $(basename $0) [-m MODE] [-e EYES] [-r] [-v] [-h]"
    echo ""
    echo "    [MODE]:"
    echo "        cat, kitty            : show kitty ascii art with sysinfo"
    echo "        catfull, cat2, kitty2 : show kitty ascii art with sysinfo (full body)"
    echo "        bunny, rabbit         : show bunny ascii art with sysinfo"
    echo "        dog, doggo, doggy     : show doggy ascii art with sysinfo"
    echo "        penguin, pengu, pingu : show penguin ascii art with sysinfo"
    echo "        minimal, simple       : show sysinfo with no ascii art"
    echo "        none, noglyph, text   : show sysinfo with text only"
    echo ""
    echo "    [EYES]:"
    echo "        Numbers from 0 to 15:"
    echo "            Selects eyes for cats, bunny, and dog"
    echo ""
    for i in {0..14}; do
        printf "        %2d:  %3s\n" "$i" "$(eyes $i)"
    done
    echo ""
    printf "        no/other number:\n"
    printf "             %3s (kitty)\n" "$(eyes 6)"
    printf "          or %3s (bunny)\n" "$(eyes 0)"
    printf "          or %3s (doggy)\n" "$(eyes 1)"
    echo ""
    echo "    [-r]            : use randomized ascii art"
    echo "    [-v]            : print the version number"
    echo "    [-h]            : print this help message"
    echo "    [no option]     : same as: $(basename $0) -m cat -e 6"
    echo "    [unkown option] : print this help message"
    echo "                      and return status code 1"
    echo ""
}

eyes() {
    case "$1" in
    0) echo ". ." ;;
    1) echo "· ·" ;;
    2) echo "^ ^" ;;
    3) echo "- -" ;;
    4) echo "~ ~" ;;
    5) echo "* *" ;;
    7) echo "-.-" ;;
    8) echo "~.~" ;;
    9) echo "*.*" ;;
    10) echo "0.0" ;;
    11) echo "0 0" ;;
    12) echo "o o" ;;
    13) echo "o.o" ;;
    14) echo "° o" ;;
    *) echo "^.^" ;;
    esac
}

# ------------------------- Fetch Functions ------------------------- #

kittyfetch() {
    echo "             \$c1\$w\$t  \$wm"
    echo "   /\_/\\     \$c3\$k\$t  \$kern"
    echo "  ( \$(eyes \$1) )    \$c2\$s\$t  \$shell"
    echo "   \$c1> \$c3^ \$c1<     \$c5\$u\$t  \$uval"
    echo "             \$c4\$b\$t  \$bval"
}

kittyfetch2() {
    echo "   /'._           \$c1\$w\$t  \$wm"
    echo "  (\$(eyes \$1) 7          \$c3\$k\$t  \$kern"
    echo "   |'-'\\"~.  .     \$c2\$s\$t  \$shell"
    echo "   Uu^~C_J._.\\"    \$c5\$u\$t  \$uval"
    echo "                  \$c4\$b\$t  \$bval"
}

bunnyfetch() {
    echo "             \$c1\$w\$t  \$wm"
    echo "   (\\ /)     \$c3\$k\$t  \$kern"
    echo "   ( \$(eyes \$1))    \$c2\$s\$t  \$shell"
    echo "   c(\$c1\\"\$t)(\$c1\\"\$t)   \$c5\$u\$t  \$uval"
    echo "             \$c4\$b\$t  \$bval"
}

puppyfetch() {
    echo "            \$c1\$w\$t  \$wm"
    echo "\$c3   /^ ^\\    \$k\$t  \$kern"
    echo "\$c3  /\$t\$c7 \$(eyes \$1) \$c3\\   \$c2\$s\$t  \$shell"
    echo "\$c3  V\\\\\$t\$c0 Y \$c3/V   \$c5\$u\$t  \$uval"
    echo "    \$c1 U\$t      \$c4\$b\$t  \$bval"
}

pingufetch() {
    echo "\$c3    W     \$c1\$w\$t  \$wm"
    echo "\$c0   (\$t\$c7'\$c3>    \$k\$t  \$kern"
    echo "\$c0  /\$t\$c7/-\\\$c0\\   \$c2\$s\$t  \$shell"
    echo "\$c0  (\$t\$c7_/\$c0)   \$c5\$u\$t  \$uval"
    echo "\$c3   ~ ~    \$c4\$b\$t  \$bval"
}

simplefetch() {
    echo "  \$c1\$w\$t  \$wm"
    echo "  \$c3\$k\$t  \$kern"
    echo "  \$c2\$s\$t  \$shell"
    echo "  \$c5\$u\$t  \$uval"
    echo "  \$c4\$b\$t  \$bval"
}

textfetch() {
    echo "\$c1 wm \$t : \$wm"
    echo "\$c3 krn\$t : \$kern"
    echo "\$c2 sh \$t : \$shell"
    echo "\$c5 up \$t : \$uval"
    echo "\$c4 bat\$t : \$bval"
}

# ------------------------- Info Collectors ------------------------- #

init() {
    for i in {0..7}; do
        printf -v "c${i}" '%b' "\e[3${i}m"
    done
    readonly d=$'\e[1m'
    readonly t=$'\e[0m'
    readonly v=$'\e[7m'

    readonly w="♥"
    readonly k=""
    readonly s=""
    readonly u="⏱"
    readonly b=""

    case "\$(uname -s)" in
    Linux*)
        readonly wm="\$(xprop -id \$(xprop -root -notype | awk '\$1==\"_NET_SUPPORTING_WM_CHECK:\"{print \$5}') -notype -f _NET_WM_NAME 8t | grep -m 1 \"WM_NAME\" | cut -f2 -d \\")"
        readonly kern="\$(uname -r | cut -f1 -d '-')"
        readonly shell=\$(basename \$SHELL)

        readonly uval="\$(uptime -p | sed 's/up //; s/ minutes/m/g; s/ minute/m/g; s/ hours/h/g; s/ hour/h/g; s/ days/d/g; s/ day/d/g')"

        if [ -d "/sys/class/power_supply/" ]; then
            BAT=\$(ls /sys/class/power_supply/ | grep -i bat)
            if [ "\$BAT" ]; then
                CAPACITY=\$(cat /sys/class/power_supply/\$BAT/capacity)
                STATUS=\$(cat /sys/class/power_supply/\$BAT/status)

                BATTERY_INFO="\$CAPACITY%"

                if [[ "\$STATUS" == "Discharging" && "\$CAPACITY" -lt 100 ]]; then
                    ENERGY=\$(cat /sys/class/power_supply/\$BAT/energy_now)
                    POWER=\$(cat /sys/class/power_supply/\$BAT/power_now)
                    if (( POWER > 0 )); then
                        REMAINING_MINUTES=\$(( ENERGY * 60 / POWER / 1000000 ))
                        HOURS=\$(( REMAINING_MINUTES / 60 ))
                        MINS=\$(( REMAINING_MINUTES % 60 ))
                        TIME_STR=""
                        [[ "\$HOURS" -gt 0 ]] && TIME_STR+="\${HOURS}h "
                        [[ "\$MINS" -gt 0 ]] && TIME_STR+="\${MINS}m"
                        BATTERY_INFO+=" (\$TIME_STR)"
                    fi
                fi
                readonly bval="\$BATTERY_INFO"
            else
                readonly bval=""
            fi
        else
            readonly bval=""
        fi
        ;;
    Darwin*)
        readonly bval="macOS: N/A"
        ;;
    *)
        readonly bval=""
        ;;
    esac

    tput clear
}

get_wm_mac() {
    local -r ps_line="\$(ps -e | grep -o \
        -e "[A]ero[S]pace" \
        -e "[y]abai" \
        -e "[A]methyst" \
        -e "[R]ectangle" \
        -e "[c]hun[k]wm" \
        -e "[k]wm" \
        -e "[S]pectacle")"

    case \$ps_line in
    *AeroSpace*) echo AeroSpace ;;
    *yabai*) echo yabai ;;
    *Amethyst*) echo Amethyst ;;
    *Rectangle*) echo Rectangle ;;
    *chunkwm*) echo chunkwm ;;
    *kwm*) echo Kwm ;;
    *Spectacle*) echo Spectacle ;;
    *) echo Quartz ;;
    esac
}

# --------------------------- Handle Args --------------------------- #

OPTSTRING=":e:m:hrv"
while getopts \${OPTSTRING} opt; do
  case \${opt} in
    v)
        echo "\${VERSION_INFO}"
        exit 0
        ;;
    h)
        help_info
        exit 0
        ;;
    m)
        MODE_CHOICE="\${OPTARG}"
        ;;
    e)
        EYES_CHOICE="\${OPTARG}"
        ;;
    r)
        RAND_CHOICE=true
        ;;
    :)
        echo "Option -\${OPTARG} requires an argument."
        echo ""
        help_info
        exit 1
        ;;
    ?)
        help_info
        exit 1
        ;;
  esac
done

# Foolproof random mode selection
if [[ "\${RAND_CHOICE}" = true ]]; then
    ANIMALS=("cat" "bunny" "dog" "penguin")
    RAND_IDX=\$((RANDOM % \${#ANIMALS[@]}))
    MODE_CHOICE="\${ANIMALS[\$RAND_IDX]}"
    EYES_CHOICE=\$((RANDOM % 15))
fi

case "\${MODE_CHOICE}" in
    cat|kitty|catfull|cat2|kitty2|bunny|rabbit|dog|doggo|doggy|penguin|pengu|pingu|minimal|simple|none|noglyph|text)
        init
        echo ""
        case "\$MODE_CHOICE" in
        cat | kitty | "")
            kittyfetch "\${EYES_CHOICE}"
            ;;
        catfull | cat2 | kitty2)
            kittyfetch2 "\${EYES_CHOICE}"
            ;;
        bunny | rabbit)
            [[ -z "\${EYES_CHOICE}" ]] && eye=0 || eye="\${EYES_CHOICE}"
            bunnyfetch "\$eye"
            ;;
        dog | doggo | doggy)
            [[ -z "\${EYES_CHOICE}" ]] && eye=1 || eye="\${EYES_CHOICE}"
            puppyfetch "\$eye"
            ;;
        penguin | pengu | pingu)
            pingufetch
            ;;
        minimal | simple)
            simplefetch
            ;;
        none | noglyph | text)
            textfetch
            ;;
        esac
        echo ""
        ;;
    *)
        init
        echo ""
        kittyfetch 6
        echo ""
        ;;
esac
EOF
}

write_starship_toml() {
cat > "$1" << 'EOF'
# Your custom starship config
format = """
$custom_time
$username
$hostname
$current_dir
$git_branch
$git_state
$git_status
$cmd_duration
$line_break
$character"""

[custom.time]
format = '⏱  $time'
command = 'date "+%H:%M:%S"'
style = "bold green"

[username]
style_user = "bold blue"
style_root = "bold red"
format = '♥  $user'

[current_dir]
prefix = "  "
truncate_to_repo = false
EOF
}

# ----------------------
# Main Install Logic
# ----------------------

echo "📁 Setting up your terminal environment..."

# Make temp dir
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Write all files
write_cutefetch "$TMP_DIR/cutefetch"
chmod +x "$TMP_DIR/cutefetch"
mkdir -p "$HOME/cutefetch"
cp "$TMP_DIR/cutefetch" "$HOME/cutefetch/cutefetch"
chmod +x "$HOME/cutefetch/cutefetch"

# Install dependencies
echo "📦 Installing required packages..."
apt update > /dev/null 2>&1 || true
apt install -y git curl wget unzip fontconfig > /dev/null 2>&1 || \
dnf install -y git curl wget unzip fontconfig > /dev/null 2>&1 || \
pacman -Sy --noconfirm git curl wget unzip fontconfig > /dev/null 2>&1

# Set up fonts
echo "🔤 Installing FiraCode Nerd Font..."
mkdir -p "$HOME/.fonts"
cd "$HOME/.fonts"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip 
unzip -o FiraCode.zip -d FiraCode > /dev/null 2>&1
rm FiraCode.zip
fc-cache -fv > /dev/null 2>&1

# Starship install
STARSHIP="$HOME/.local/bin/starship"
mkdir -p "$(dirname "$STARSHIP")"
if [ ! -f "$STARSHIP" ]; then
    echo "📥 Downloading Starship..."
    curl -sS https://starship.rs/install.sh  | sh -s -- -y > /dev/null 2>&1
fi

# Starship config
write_starship_toml "$TMP_DIR/starship.toml"
mkdir -p "$HOME/.config"
cp "$TMP_DIR/starship.toml" "$HOME/.config/starship.toml"

# Add to PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/cutefetch/cutefetch" "$HOME/.local/bin/cutefetch" > /dev/null 2>&1

# Backup and add to rc file
if [ -f "$CONFIG_FILE" ]; then
    echo "💾 Backing up $CONFIG_FILE"
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
echo "🎉 All set! Restart your shell with:"
echo "exec $SHELL_NAME"