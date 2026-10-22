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

# 3. SDDM Theme (Requires sudo)
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

# 4. Reload Omarchy
if command -v omarchy >/dev/null 2>&1; then
    echo "-> Restarting Omarchy shell to apply changes..."
    omarchy restart shell || true
fi

echo "=== Done! All configurations have been applied. ==="
