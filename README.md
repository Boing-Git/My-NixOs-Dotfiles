# ❄️ NixOS & Quickshell Dotfiles

> A highly customized, dynamic desktop environment built on **NixOS**, **Hyprland**, and **Quickshell** — centered around expressive, real-time **Material Design 3** theming and a modular QML architecture.

![NixOS](https://img.shields.io/badge/NixOS-Flakes-5277C3?style=flat-square&logo=nixos&)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58E1FF?style=flat-square)
![Quickshell](https://img.shields.io/badge/Shell-Quickshell-8B5CF6?style=flat-square)
![Matugen](https://img.shields.io/badge/Theming-Matugen_v4-F59E0B?style=flat-square)
![License](https://img.shields.io/badge/license-GNU-green?style=flat-square)

---

## 📋 Table of Contents

- [Stack](#stack)
- [Dynamic Theming](#dynamic-theming)
- [Repository Structure](#repository-structure)
- [Dotfile Symlinking](#dotfile-symlinking)
- [Installation](#installation)
- [Quickshell Architecture](#quickshell-architecture)

---

<a id="stack"></a>

## 🧩 Stack

| Category | Tool / Technology |
|---|---|
| **OS** | NixOS (Flakes + Home Manager) |
| **Window Manager** | Hyprland (Wayland) |
| **Desktop Shell** | Quickshell (QtQuick / QML + JS) |
| **Theming Engine** | Matugen v4 (Material 3 colors) |
| **Terminal** | Foot |
| **File Manager** | Thunar |

---

<a id="dynamic-theming"></a>

## 🎨 Dynamic Material 3 Theming

This configuration features a **fully integrated real-time theming pipeline**. Switching the wallpaper shifts the entire system palette — instantly.

### How It Works

```
Wallpaper Image
     │
     ▼
Matugen v4  ──>  Extracts colors  ──>  Generates Material 3 hex palette
     │
     ▼
Home Manager Templates
  ├── footTheme.ini       (Foot terminal colors)
  └── quickshellColors.js (Quickshell UI palette)
     │
     ▼
Live UI + Terminal refresh
```

### Changing the Theme

To change the wallpaper and regenerate the system palette on the fly:

```bash
matugen image /path/to/your/wallpaper.jpg
```

> **Supported formats:** `jpg`, `jpeg`, `png`, `webp`, `gif`

---

<a id="repository-structure"></a>

## 📂 Repository Structure

```
.
├── flake.lock
├── flake.nix
├── hosts
│   └── nixos
│       ├── default.nix
│       └── hardware-configuration.nix
├── LICENSE
├── modules
│   ├── home
│   │   ├── default.nix
│   │   ├── programs
│   │   │   ├── git.nix
│   │   │   ├── neovim.nix
│   │   │   ├── spicetify.nix
│   │   │   ├── vscodium.nix
│   │   │   └── zed.nix
│   │   ├── symlinks.nix
│   │   └── ui
│   │       ├── gtk.nix
│   │       └── qt.nix
│   └── system
│       ├── core
│       │   ├── boot.nix
│       │   ├── environment.nix
│       │   ├── networking.nix
│       │   └── users.nix
│       ├── desktop
│       │   ├── fonts.nix
│       │   ├── graphics.nix
│       │   └── greetd.nix
│       ├── programs
│       │   ├── default.nix
│       │   └── packages.nix
│       └── services
│           ├── services.nix
│           ├── surinder-setup.nix
│           └── virt-management.nix
├── README.md
└── scripts
    └── install.sh
```

---

<a id="dotfile-symlinking"></a>

## 🔗 Out-of-Store Dotfile Symlinking

To allow for rapid iteration and live editing without needing to rebuild the NixOS system for every small tweak, this configuration uses **out-of-store symlinking** via Home Manager.

### How It Works

Defined in `modules/home/symlinks.nix`, Home Manager's `mkOutOfStoreSymlink` is used to map standard configuration folders (like `hypr`, `quickshell`, `nvim`, `foot`, etc.) from a local `~/dotfiles/` directory directly into your `~/.config/` directory.

- **Standard NixOS behavior:** Files managed by Nix are placed into the read-only `/nix/store/` and symlinked to your home directory, making them immutable. You must run `nixos-rebuild` to apply any changes.
- **Out-of-Store approach:** By symlinking them to `~/dotfiles/`, the files exposed in `~/.config/` remain mutable. You can edit your Hyprland configuration or Quickshell QML files live and see the changes instantly, bypassing the Nix store completely.

> **Note:** Ensure your standalone dotfiles are placed in the `~/dotfiles/` directory for these symlinks to resolve correctly!

---

<a id="installation"></a>

## 🚀 Installation

> **Prerequisites:** Nix with Flakes enabled. See the [NixOS wiki on Flakes](https://nixos.wiki/wiki/Flakes) if needed.

Choose one of the following methods to install the configuration:

### Option A: Automatic

If you have already cloned the repository or downloaded the script, you can run it directly:

```bash
chmod +x install.sh
./install.sh
```

### Option B: Manual

If you prefer to run the steps manually, follow these instructions (which mirror the installation script):

#### Step 1 — Clone the Main Repository

```bash
git clone https://github.com/Boing-Git/NixOs-Dotfiles ~/Nixos
cd ~/Nixos
```

#### Step 2 — Clone Quickshell Dotfiles

```bash
mkdir -p ~/.config/quickshell
git clone https://github.com/Boing-Git/Quickshell-Dotfiles ~/.config/quickshell
```

#### Step 3 — Clone Hyprland Dotfiles

```bash
mkdir -p ~/.config/hypr
git clone https://github.com/Boing-Git/Hyprland-Dotfiles ~/.config/hypr
```

#### Step 4 — Copy Your Hardware Config

Copy your system's generated hardware configuration into the flake directory:

```bash
cp /etc/nixos/hardware-configuration.nix ./
```

#### Step 5 — Apply the Configuration

Rebuild your NixOS system using the flake:

> Replace `nixos` with your hostname in the flake path if it differs.

```bash
sudo nixos-rebuild switch --flake .#nixos
```

#### Step 6 — Set a Wallpaper and Generate the Theme

```bash
matugen image /path/to/your/wallpaper.jpg
```

---

<a id="quickshell-architecture"></a>

## 🛠️ Quickshell Architecture

The UI is built **entirely from scratch** using Quickshell — blending QML for declarative, GPU-accelerated layouts with JavaScript for state and math logic.

### Design Principles

**Reactive Geometry**
Border radii, spacing, and layout values are computed dynamically in JS and passed into QML properties — no hardcoded magic numbers.

**Component Isolation**
Each surface (bar, launcher, wallpaper switcher, workspace indicator, Wi-Fi and Bluetooth modules, volume OSD, screenshot tool) lives in its own `.qml` file. No monoliths.

**Centralized Theming**
All color tokens live in `Variables/colors.js` as `Colors.*` constants. Layout and geometry constants live in `Variables/variables.js`. Components import and consume them; nothing is defined locally.

### Component Overview

| File | Purpose |
|---|---|
| `shell.qml` | Root component — global keybinds and module imports |
| `StatusBar.qml` | Top bar container that hosts all pill modules |
| `TopPills.qml` | Pill group layout wiring Wifi, Bluetooth, Clock, and other modules |
| `ClockPill.qml` | Clock display rendered as a pill-shaped widget |
| `HyprWorkspaces.qml` | Hyprland workspace switcher |
| `WallpaperSwitcher.qml` | Wallpaper picker integrated with Matugen + swww |
| `Launcher.qml` | Application launcher |
| `Bluetooth.qml` | Bluetooth status and control module |
| `Wifi.qml` | Wi-Fi status and control module |
| `VolumeOsd.qml` | Volume on-screen display overlay |
| `ScreenShot.qml` | Screenshot capture UI |
| `PhysicsString.qml` | Physics-based string animation component |
| `StringOverlay.qml` | Overlay layer that renders the physics string |
| `Variables/colors.js` | Single source of truth for all color tokens (`Colors.*`) |
| `Variables/variables.js` | Centralized layout, spacing, and geometry constants |

---

> *This README was improved with AI assistance. The underlying configuration is entirely hand-crafted.*
