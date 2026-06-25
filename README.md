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

---

<a id="dynamic-theming"></a>

## 🎨 Dynamic Material 3 Theming

This configuration features a **fully integrated real-time theming pipeline**. Switching the wallpaper shifts the entire system palette — instantly.

### How It Works

```
Wallpaper Image
     │
     ▼
Matugen v4  ──→  Extracts colors  ──→  Generates Material 3 hex palette
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

That single command triggers color extraction, template injection, and UI refresh across all themed components.

---

<a id="repository-structure"></a>

## 📂 Repository Structure

```
├── app.fish
├── configuration.nix
├── flake.nix
├── hardware-configuration.nix
├── LICENSE
├── modules
│   ├── HM
│   │   ├── BigPackConfigs
│   │   │   ├── Matugen
│   │   │   │   └── Matugen.nix
│   │   │   ├── terminal
│   │   │   │   ├── foot.nix
│   │   │   │   └── starship.nix
│   │   │   ├── text-editor
│   │   │   │   ├── vscodium.nix
│   │   │   │   └── zed.nix
│   │   │   ├── UI-Frameworks
│   │   │   │   ├── gtk.nix
│   │   │   │   └── qt.nix
│   │   │   └── zen
│   │   │       ├── app.fish
│   │   │       ├── userChrome.css
│   │   │       └── zen.nix
│   │   ├── home.nix
│   │   └── PackConfig.nix
│   └── programs.nix
└── README.md
```

---

<a id="installation"></a>

## 🚀 Installation

> **Prerequisites:** Nix with Flakes enabled. See the [NixOS wiki on Flakes](https://nixos.wiki/wiki/Flakes) if needed.

**1. Clone the repository**

```bash
git clone <your-repo-url> ~/Nixos
cd ~/Nixos
```

**2. Apply the configuration**

Using Home Manager directly:

```bash
nix run nixpkgs#home-manager -- switch --flake .#<your-hostname>
```

Or rebuild your NixOS system (if Home Manager is managed in your flake):

```bash
sudo nixos-rebuild switch
```

**3. Set an initial wallpaper and generate the theme**

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

> *This README was significantly improved with AI assistance. The underlying configuration is entirely hand-crafted.*
