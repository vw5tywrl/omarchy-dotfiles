# Omarchy Dotfiles & Customizations

Clean, modular configuration files and custom plugins for [Omarchy](https://omarchy.org/) (Hyprland running on Arch Linux).

---

## Highlights & Features

### 1. Unified Caps Lock Indicator ("X")
A consistent, minimalist visual indicator shaped as an `X` that notifies when Caps Lock is active across all system levels:
- **Topbar**: Dedicated widget in the Omarchy bar (`loathe.capslock`).
- **Lock Screen**: Displayed on the right edge of the password box alongside the password-visibility eye toggle and fingerprint icon (`loathe.lock`).
- **SDDM Login Screen**: Rendered inside the login password box at startup (`system/sddm-theme/Main.qml`).

### 2. Topbar Layout & Shell Plugins (`shell.json`)
- **Center Cluster (`centerBegin` / `center` / `centerEnd`)**: System indicators, OmaControl (`io.github.twiking.omacontrol`), clock (`ddd d MMM HH:mm`), multi-city world clock (`omarchy.elsewhen` for Rome, Dubai, Tokyo, Los Angeles, New York), weather, Caps Lock indicator (`loathe.capslock`), and system update indicator.
- **Left & Right Clusters**: App launcher, workspaces, media player (`omarchy.media`), tray, keyboard layout, plugin manager (`omaplug`), Tailscale (`omarchy.tailscale`), AI agent switcher (`agentselector.agents`), custom Bluetooth panel (`loathe.bluetooth`), audio, network, monitor, battery percentage (`omarchy.power`), and power menu (`vinicgobbi.power`).
- **Custom AI Quota Plugin**: Includes `loathe.agents` and helper `.local/bin/omarchy-agent-usage-antigravity`.

### 3. Omarchy Menu Extension (`extensions/omarchy-menu.jsonc`)
- Adds **`Setup → Startup`** (`setup.startup`, searchable via `omastart`, `autostart`, and `omarchy-startup`) to launch [OmaStart](https://github.com/vw5tywrl/omarchy-startup) directly from the Omarchy menu.

### 4. Hyprland & Keybindings (`hypr/`)
- **Keyboard Layout**: Italian + US layouts with switching via `Super + Space` (`input.lua`).
- **Application Launcher**: Omarchy menu rebound to `Super + D` (`bindings.lua`).
- **Firefox-Only Shortcut Cleanup**: Unbound default Chromium web-app `Super + Shift + *` shortcuts in `bindings.lua`, paired with Firefox default handler associations in `mimeapps.list`.
- **Window Rules & OmaControl Integration**: Loads `hypr.omacontrol` (`omacontrol.lua`) and floats/centers OmaStart's initial `Select Startup Mode` prompt (`680×370`) in `hyprland.lua`.
- **Input & Display**: Adjusted mouse sensitivity and monitor scaling set to `1.25x` (`input.lua`, `monitors.lua`).
- **Language Server**: Lua LS stubs and diagnostics configured for Hyprland (`.luarc.json`).

### 5. Fonts & Terminal Configurations
- **System Monospace Font**: `fontconfig/fonts.conf` binds **JetBrainsMono Nerd Font** as the primary desktop `monospace` font.
- **Unified Terminals**: Harmonized configs for **Alacritty**, **Ghostty**, **Kitty**, and **Foot** using **JetBrainsMono Nerd Font** (size 11) with consistent padding and cursor styling.

### 6. System Environment, Hooks & Toolchains
- **Environment (`environment.d/`)**:
  - Native Wayland enabled for Firefox (`omarchy-firefox-wayland.conf`).
  - Intel `i965` VA-API hardware video acceleration configured for ThinkPad T430 (`t430-vaapi.conf`).
- **Theme Hook**: `omarchy/hooks/theme-set.d/10-owe-sync` refreshes the `owe` daemon automatically on theme changes.
- **Default AI Agent**: Set to `agy` (Antigravity) in `omarchy/defaults/agent`.
- **Process Monitor & Toolchains**: Custom `btop` layout (`btop/btop.conf`) and `mise` settings (`mise/config.toml`).

### 7. Custom & Community Themes
- **Apollo After Dark (True-Black Edition)**: Customized in `omarchy/themes/apollo-after-dark/` (`colors.toml` and `shell.lock.toml`) from [`leaflessbranch/omarchy-apollo-after-dark-theme`](https://github.com/leaflessbranch/omarchy-apollo-after-dark-theme) with `#000000` true-black backgrounds and `#FFFFFF` high-contrast typography tuned for TN panels.
- **DHV Magellan**: Automatically cloned by `install.sh` from [`tami1A84/omarchy-dhv-magellan-theme`](https://github.com/tami1A84/omarchy-dhv-magellan-theme).

---

## Repository Structure

```text
dotfiles/
├── .config/
│   ├── alacritty/          # Alacritty terminal config
│   ├── btop/               # btop process monitor config
│   ├── environment.d/      # Wayland Firefox & T430 VA-API env vars
│   ├── fontconfig/         # JetBrainsMono Nerd Font monospace binding
│   ├── foot/               # Foot terminal config
│   ├── ghostty/            # Ghostty terminal config
│   ├── hypr/               # Hyprland (bindings, input, monitors, omacontrol, .luarc.json)
│   ├── kitty/              # Kitty terminal config
│   ├── mimeapps.list       # Default browser & MIME associations (Firefox)
│   ├── mise/               # mise settings
│   └── omarchy/            # Omarchy bar layout (shell.json/toml), extensions, hooks, themes & plugins
│       ├── defaults/       # Default AI agent preference (agy)
│       ├── extensions/     # Custom Omarchy menu entries (omarchy-menu.jsonc)
│       ├── hooks/          # Event hooks (theme-set.d/10-owe-sync)
│       ├── plugins/
│       │   ├── loathe.agents/     # AI monitor widget & provider icons
│       │   ├── loathe.bluetooth/  # Bluetooth management widget
│       │   ├── loathe.capslock/   # Topbar Caps Lock indicator
│       │   └── loathe.lock/       # Lock screen with Caps Lock & eye toggle
│       └── themes/
│           └── apollo-after-dark/ # Customized Apollo After Dark theme (true-black & white text)
├── .local/
│   └── bin/
│       └── omarchy-agent-usage-antigravity  # Quota sync script
├── system/
│   └── sddm-theme/
│       └── Main.qml        # Custom SDDM theme with Caps Lock indicator & eye toggle
├── install.sh              # Automated deployment & git-plugin bootstrap script
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
2. Installs helper scripts into `~/.local/bin/` with execute permissions.
3. Clones git-managed third-party Omarchy plugins (`omaplug`, `omacontrol`, `agentselector.agents`, `vinicgobbi.power`, `liambeck99.update-center`) and themes (`dhv-magellan`) if not already installed.
4. Prompts whether to deploy the customized SDDM login screen theme (`Main.qml`).
5. Reloads the Omarchy shell to activate all widgets and bar layouts immediately.
