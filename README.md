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

### 5. Configurazioni Terminali
- Configurazioni coordinate per **Alacritty**, **Ghostty**, **Kitty** e **Foot** con font JetBrainsMono Nerd Font (size 11) e gestione del padding uniforme.

---

## Struttura della repository

```text
dotfiles/
├── .config/
│   ├── hypr/               # Hyprland (bindings, input, monitors, autostart)
│   ├── omarchy/            # Layout barra, shell.json/toml e plugin custom
│   │   └── plugins/
│   │       ├── loathe.agents/
│   │       ├── loathe.bluetooth/
│   │       ├── loathe.capslock/
│   │       └── loathe.lock/
│   ├── alacritty/          # Configurazione Alacritty
│   ├── kitty/              # Configurazione Kitty
│   ├── foot/               # Configurazione Foot
│   └── ghostty/            # Configurazione Ghostty
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
git clone <URL_DELLA_TUA_REPO> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Lo script installerà i file in `~/.config`, renderà eseguibili gli script in `~/.local/bin`, chiederà se applicare la personalizzazione SDDM e riavvierà la shell di Omarchy.
