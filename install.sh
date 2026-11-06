#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Omarchy Dotfiles Installer ==="
echo "Installing dotfiles from: $DOTFILES_DIR"

# 1. Config directory (including hidden files)
echo "-> Deploying user configs to ~/.config..."
mkdir -p ~/.config
cp -a "$DOTFILES_DIR/.config/." ~/.config/

# 2. Local bin scripts
echo "-> Deploying helper scripts to ~/.local/bin..."
mkdir -p ~/.local/bin
cp -a "$DOTFILES_DIR/.local/bin/." ~/.local/bin/
chmod +x ~/.local/bin/*

# 3. Git-managed third-party Omarchy plugins & themes
echo "-> Checking git-managed Omarchy plugins & themes..."
mkdir -p ~/.config/omarchy/plugins ~/.config/omarchy/themes

install_git_plugin() {
    local id="$1"
    local url="$2"
    if [ ! -d "$HOME/.config/omarchy/plugins/$id" ]; then
        echo "   Installing plugin $id..."
        if command -v omarchy >/dev/null 2>&1; then
            omarchy plugin add "$url" --yes || git clone "$url" "$HOME/.config/omarchy/plugins/$id"
        else
            git clone "$url" "$HOME/.config/omarchy/plugins/$id"
        fi
    fi
}

install_git_plugin "agentselector.agents" "https://github.com/ridgegate/omarchy-agents.git"
install_git_plugin "io.github.twiking.omacontrol" "https://github.com/twiking/omacontrol.git"
install_git_plugin "liambeck99.update-center" "https://github.com/liambeck99/omarchy-update-center.git"
install_git_plugin "omaplug" "https://github.com/fross100/omaplug.git"
install_git_plugin "vinicgobbi.power" "https://github.com/vinicgobbi/omarchy-plugin-power.git"

if [ ! -d "$HOME/.config/omarchy/themes/dhv-magellan" ]; then
    echo "   Installing theme dhv-magellan..."
    git clone "https://github.com/tami1A84/omarchy-dhv-magellan-theme.git" "$HOME/.config/omarchy/themes/dhv-magellan"
fi

# 4. SDDM Theme (Requires sudo)
if [ -d "/usr/share/sddm/themes/omarchy" ]; then
    read -p "Do you want to install the custom SDDM theme with Caps Lock indicator? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "-> Backing up existing SDDM Main.qml and installing custom version..."
        sudo cp -n /usr/share/sddm/themes/omarchy/Main.qml /usr/share/sddm/themes/omarchy/Main.qml.orig 2>/dev/null || true
        sudo cp "$DOTFILES_DIR/system/sddm-theme/Main.qml" /usr/share/sddm/themes/omarchy/Main.qml
        echo "   SDDM theme updated successfully!"
    fi
fi

# 5. Reload Omarchy
if command -v omarchy >/dev/null 2>&1; then
    echo "-> Restarting Omarchy shell to apply changes..."
    omarchy restart shell || true
fi

echo "=== Done! All configurations have been applied. ==="
