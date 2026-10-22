# Omarchy Dotfiles & Customizations

Clean, modular configuration files and custom plugins for [Omarchy](https://omarchy.org/) (Hyprland running on Arch Linux).

---

## Highlights & Features

### 1. Unified Caps Lock Indicator ("X")
A consistent, minimalist visual indicator shaped as an `X` that notifies when Caps Lock is active across all system levels:
- **Topbar**: Dedicated widget in the Omarchy bar (`loathe.capslock`).
- **Lock Screen**: Displayed on the left side of the password field during suspend/lock (`loathe.lock`).
- **SDDM Login Screen**: Rendered inside the login password box at startup (`system/sddm-theme/Main.qml`).

### 2. AI Usage Monitor & Topbar Widget
- Bar widget to monitor usage and rate limits across AI models (`loathe.agents`).
- Custom "AI" glyph using bold JetBrainsMono Nerd Font.
- Quota computation and refresh helper located at `.local/bin/omarchy-agent-usage-antigravity`.

### 3. Bluetooth Widget
- Panel and status bar widget for quickly managing Bluetooth device pairing and connection states (`loathe.bluetooth`).

### 4. Hyprland & Keybindings
- **Keyboard Layout**: Italian + US layouts with seamless switching via `Super + Space` (`input.lua`).
- **Application Launcher**: Omarchy menu rebound to `Super + D` (`bindings.lua`).
- **Input & Display**: Adjusted mouse sensitivity and monitor scaling set to 1.25x (`input.lua`, `monitors.lua`).
- **Language Server**: Lua LS stubs and diagnostics configured for Hyprland (`.luarc.json`).

### 5. Unified Terminal Configurations
- Polished, harmonized configs for **Alacritty**, **Ghostty**, **Kitty**, and **Foot**:
  - Consistent typography using **JetBrainsMono Nerd Font** (size 11).
  - Uniform internal padding and cursor styling.

### 6. System Environment & Toolchains
- **Environment**: Native Wayland enabled for Firefox (`environment.d/omarchy-firefox-wayland.conf`).
- **Process Monitor**: Custom `btop` configuration with PID process sorting and preferred panel layout (`btop/btop.conf`).
- **Toolchain Manager**: `mise` configuration for developer runtime versions (`mise/config.toml`).
- **Default Agent**: Configured agent preference in `omarchy/defaults/agent`.

---

## Repository Structure

```text
dotfiles/
├── .config/
│   ├── alacritty/          # Alacritty terminal config
│   ├── btop/               # btop process monitor config
│   ├── environment.d/      # Environment variables (native Wayland Firefox)
│   ├── foot/               # Foot terminal config
│   ├── ghostty/            # Ghostty terminal config
│   ├── hypr/               # Hyprland (bindings, input, monitors, autostart, .luarc.json)
│   ├── kitty/              # Kitty terminal config
│   ├── mise/               # mise runtime and toolchain config
│   └── omarchy/            # Omarchy bar layout (shell.json/toml) & custom plugins
│       ├── defaults/       # Default agent preference
│       └── plugins/
│           ├── loathe.agents/     # AI monitor widget & provider icons
│           ├── loathe.bluetooth/  # Bluetooth management widget
│           ├── loathe.capslock/   # Topbar Caps Lock indicator
│           └── loathe.lock/       # Lock screen with Caps Lock indicator
├── .local/
│   └── bin/
│       └── omarchy-agent-usage-antigravity  # Quota sync script
├── system/
│   └── sddm-theme/
│       └── Main.qml        # Custom SDDM theme with Caps Lock indicator
├── install.sh              # Automated deployment script
├── .gitignore
└── README.md
```

---

## Installation & Deployment

To apply these configurations on a fresh Omarchy system:

```bash
git clone https://github.com/vw5tywrl/omarchy-dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### What `install.sh` does:
1. Copies all user configuration files (including dotfiles) to `~/.config/`.
2. Installs helper scripts into `~/.local/bin/` with proper execute permissions.
3. Prompts whether to deploy the customized SDDM login screen theme (`Main.qml`).
4. Gracefully reloads the Omarchy shell to activate all widgets and bar layouts immediately.
