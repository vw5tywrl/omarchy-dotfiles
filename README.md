# Omarchy Dotfiles & Customizations

Repository contenente le configurazioni e personalizzazioni per [Omarchy](https://omarchy.org/) (Hyprland su Arch Linux).

## Caratteristiche incluse

### 1. Indicatore Caps Lock ("X") coerente
Un indicatore visivo minimal a forma di "X" che segnala se il Caps Lock è attivo in tutte le schermate chiave:
- **Topbar**: widget dedicato sulla barra di Omarchy (`loathe.capslock`).
- **Lock Screen**: compare a sinistra del box password durante la sospensione/blocco schermo (`loathe.lock`).
- **Schermata di Login SDDM**: compare all'interno del campo password all'avvio (`system/sddm-theme/Main.qml`).

### 2. Monitor AI Usage & Icona Topbar
- Widget dedicato sulla topbar per monitorare lo stato e l'utilizzo dei modelli AI (`loathe.agents`).
- Icona personalizzata "AI" in JetBrainsMono Nerd Font Bold sulla barra.
- Script ausiliario di aggiornamento e conteggio quote in `.local/bin/omarchy-agent-usage-antigravity`.

### 3. Widget Bluetooth
- Pannello e widget per la gestione rapida delle connessioni Bluetooth (`loathe.bluetooth`).

### 4. Hyprland & Scorciatoie
- **Layout tastiera**: Italiano + US con switch rapido tramite `Super + Spazio` (`input.lua`).
- **Menu principale**: apertura del menu Omarchy rimappata su `Super + D` (`bindings.lua`).
- **Sensibilità mouse**: ottimizzata per precisione (`input.lua`).
- **Monitors & scaling**: scala monitor impostata a 1.25x (`monitors.lua`).
- **Lua LS stubs**: configurazione LSP per Hyprland (`.luarc.json`).

### 5. Configurazioni Terminali
- Configurazioni coordinate per **Alacritty**, **Ghostty**, **Kitty** e **Foot** con font JetBrainsMono Nerd Font (size 11) e gestione del padding uniforme.

### 6. Sistema e Toolchain
- **Environment**: Abilitazione Wayland nativo per Firefox (`environment.d/omarchy-firefox-wayland.conf`).
- **Monitor di sistema**: Configurazione personalizzata di `btop` (ordinamento processi per PID, layout box) in `btop/btop.conf`.
- **Toolchain di sviluppo**: Toolchain `mise` configurata per i runtime in `mise/config.toml`.
- **Agent di default**: Preferenza agent in `omarchy/defaults/agent`.

---

## Struttura della repository

```text
dotfiles/
├── .config/
│   ├── alacritty/          # Configurazione Alacritty
│   ├── btop/               # Configurazione btop (process monitor)
│   ├── environment.d/      # Variabili d'ambiente (Firefox Wayland)
│   ├── foot/               # Configurazione Foot
│   ├── ghostty/            # Configurazione Ghostty
│   ├── hypr/               # Hyprland (bindings, input, monitors, autostart, .luarc.json)
│   ├── kitty/              # Configurazione Kitty
│   ├── mise/               # Configurazione mise (runtimes / tools)
│   └── omarchy/            # Layout barra, shell.json/toml e plugin custom
│       ├── defaults/       # Default agent
│       └── plugins/
│           ├── loathe.agents/
│           ├── loathe.bluetooth/
│           ├── loathe.capslock/
│           └── loathe.lock/
├── .local/
│   └── bin/
│       └── omarchy-agent-usage-antigravity
├── system/
│   └── sddm-theme/
│       └── Main.qml        # Tema SDDM personalizzato con Caps Lock indicator
├── install.sh              # Script di installazione automatica
└── README.md
```

---

## Installazione / Ripristino

Su una nuova installazione di Omarchy:

```bash
git clone https://github.com/vw5tywrl/omarchy-dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Lo script installerà i file in `~/.config`, renderà eseguibili gli script in `~/.local/bin`, chiederà se applicare la personalizzazione SDDM e riavvierà la shell di Omarchy.
