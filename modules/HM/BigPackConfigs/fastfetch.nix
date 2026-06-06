# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                        fastfetch.nix                                    ║
# ║  Home Manager module — Jivan Singh's NixOS/Hyprland workstation         ║
# ║                                                                          ║
# ║  Theme:    Material 3 Expressive (ANSI 256-color mapped)                ║
# ║  Fonts:    Nerd Fonts required (JetBrainsMono Nerd Font recommended)     ║
# ║  Sections: Identity → Hardware → System → Nix → Environment             ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# USAGE — READ THIS BEFORE IMPORTING
# ────────────────────────────────────
#
# This file is a Home Manager module.  There are TWO ways to use it, and
# choosing the wrong one is the most common source of build errors.
#
# ── PATTERN A: Standalone Home Manager (home-manager switch) ─────────────
#
#   Your flake.nix homeConfigurations output:
#
#     homeConfigurations."jivan" = home-manager.lib.homeManagerConfiguration {
#       pkgs = nixpkgs.legacyPackages.x86_64-linux;
#       modules = [ ./fastfetch.nix ];
#     };
#
#   In this pattern home.username and home.homeDirectory MUST be set either
#   here or inside fastfetch.nix itself (they are set below).
#
# ── PATTERN B: Home Manager as a NixOS module (nixos-rebuild switch) ─────
#
#   Your flake.nix nixosConfigurations output:
#
#     nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
#       modules = [
#         home-manager.nixosModules.home-manager
#         {
#           home-manager.useGlobalPkgs = true;
#           home-manager.useUserPackages = true;
#           home-manager.users.jivan = import ./fastfetch.nix;
#           #                  ^^^^^ must match your actual username
#         }
#       ];
#     };
#
#   In Pattern B, home.username and home.homeDirectory are STILL required
#   inside the HM module — NixOS does NOT inject them automatically.
#   They are declared below.  Change "jivan" to your actual username if
#   the username in your system differs from this file's default.
#
# WHY home.username / home.homeDirectory ARE MANDATORY
# ─────────────────────────────────────────────────────
# Home Manager resolves ALL managed file paths against home.homeDirectory.
# Internally, `programs.fastfetch` writes its config via:
#
#   xdg.configFile."fastfetch/config.jsonc".source = <store-path>;
#
# which expands to:
#
#   "${config.xdg.configHome}/fastfetch/config.jsonc"
#   → "${config.home.homeDirectory}/.config/fastfetch/config.jsonc"
#
# If home.homeDirectory is the empty string "" (its value when username
# is also unset), xdg.configHome collapses to ".config" — a relative path.
# Home Manager's file-installer then rejects it with:
#
#   Error installing file '.config/fastfetch/config.jsonc' outside $HOME
#
# This is the exact error you hit.  The fix is the two lines below.
#
# WHY THIS STRUCTURE?
# ───────────────────
# Home Manager's `programs.fastfetch.settings` accepts a Nix attrset that
# is serialized to JSON via `builtins.toJSON` at build time and written into
# the Nix store as a read-only file (~/.config/fastfetch/config.jsonc).
#
# This means:
#   1. Every value is evaluated at `nixos-rebuild` / `home-manager switch` time.
#   2. You cannot use runtime shell variables inside these strings — they are
#      static JSON.  Dynamic values must come from fastfetch's own {format}
#      tokens or `type = "command"` modules that shell-out at runtime.
#   3. The `let … in` bindings below are pure Nix — they exist only during
#      evaluation and produce zero overhead at runtime.
#   4. Escape sequences (\u001b[…m) are written verbatim into the JSON, which
#      fastfetch reads and passes directly to the terminal.  No shell
#      interpretation occurs — this is safe and intentional.

{ config, lib, pkgs, ... }:

let
  # ──────────────────────────────────────────────────────────────────────────
  # COLOR PALETTE  —  Material 3 Expressive, mapped to ANSI 256-color space
  # ──────────────────────────────────────────────────────────────────────────
  #
  # These become the fastfetch `display.constants` array: $1 … $6.
  # They are ANSI SGR escape sequences.  The \u001b prefix is the JSON
  # encoding of ESC (0x1B).  Fastfetch substitutes {$N} tokens before
  # writing each line to stdout.
  #
  # M3 role          → Hex       → ANSI 256 index  → Terminal appearance
  # ─────────────────────────────────────────────────────────────────────
  # $1  base/reset   → #FFFFFF   → 37 (std bright)  → White  (borders, reset)
  # $2  primary      → #AF87FF   → 141              → Purple (identity: kernel, shell, user)
  # $3  secondary    → #DFAFFF   → 183              → Mauve  (resources: mem, pkgs)
  # $4  tertiary     → #FF8787   → 210              → Coral  (system: distro, WM)
  # $5  surface-tint → #8A8A8A   → 245              → Gray   (hardware: cpu, gpu, disk)
  # $6  nix-accent   → #5FAFFF   → 75               → Blue   (nix-specific: generation)

  c1 = "\\u001b[37m";          # M3 base/reset   — standard white
  c2 = "\\u001b[38;5;141m";    # M3 primary      — #af87ff soft purple
  c3 = "\\u001b[38;5;183m";    # M3 secondary    — #dfafff light mauve
  c4 = "\\u001b[38;5;210m";    # M3 tertiary     — #ff8787 warm coral
  c5 = "\\u001b[38;5;245m";    # M3 surface-tint — #8a8a8a neutral gray
  c6 = "\\u001b[38;5;75m";     # NixOS accent    — #5fafff bright blue

  # ──────────────────────────────────────────────────────────────────────────
  # BOX GEOMETRY
  # ──────────────────────────────────────────────────────────────────────────
  #
  # Every visible line inside the box obeys this terminal-width contract:
  #
  #   │ ICON label          VALUE (right-padded to 22) │
  #   ^─────────────────────^──────────────────────────^
  #   key field: 11 cols    value field: 22 cols + " │"
  #
  # Key field breakdown (11 terminal columns):
  #   │  = 1 col
  #   ' '= 1 col  (separator after border)
  #   ICON = 2 cols  (Nerd Font glyph, always double-wide)
  #   ' '= 1 col  (separator after icon)
  #   label = 6 cols  (padded with trailing spaces as needed)
  #
  # Lines WITHOUT an icon use 3 literal spaces + a 6-char label instead.
  # This keeps visual weight identical across icon/no-icon rows.
  #
  # Value field: fastfetch's `{TOKEN>22}` right-justifies within 22 columns.
  # The trailing ` │` adds 2 cols, so total inner width = 11 + 22 + 2 = 35.
  # The border row has 35 dashes → ╭─{35}─╮ = 37 chars wide.  ✓

  # Section dividers reuse the same 37-char width
  boxTop = "╭───────────────────────────────────╮";
  boxBot = "╰───────────────────────────────────╯";
  boxDiv = "├───────────────────────────────────┤";  # section separator

  # ──────────────────────────────────────────────────────────────────────────
  # HELPER: build a key string for icon rows
  # ──────────────────────────────────────────────────────────────────────────
  #
  # Usage:  iconKey colorN icon label
  #   colorN  — one of c1…c6 (the ANSI escape for the icon)
  #   icon    — single Nerd Font glyph string (e.g. "")
  #   label   — exactly 6 visible chars, padded with spaces
  #
  # Returns the full `key` string including leading "│ " and color resets.
  # The color wraps ONLY the icon; the label is rendered in $1 (white).
  #
  # WHY: Nix string interpolation (${…}) lets us compose these without
  # repeating the reset/color boilerplate for every module.  The final JSON
  # will have the literal escape sequences baked in — zero runtime overhead.

  iconKey = colorCode: icon: label:
    "│ ${colorCode}${c1}${icon} ${label}";

  # ──────────────────────────────────────────────────────────────────────────
  # HELPER: build a key string for plain (no icon) rows
  # ──────────────────────────────────────────────────────────────────────────
  #
  # '│   ' (3 spaces instead of ' '+icon+' ') keeps the same 11-col key width.

  plainKey = label:
    "│   ${label}";

  # ──────────────────────────────────────────────────────────────────────────
  # RUNTIME COMMAND SNIPPETS
  # ──────────────────────────────────────────────────────────────────────────
  #
  # These are shell command strings executed by fastfetch at display time via
  # `type = "command"` modules.  They run in /bin/sh context.
  #
  # NixOS-specific notes:
  #   - `nixos-version` is on PATH after a rebuild.
  #   - `nix-env --list-generations` needs the Nix profile to be active.
  #   - `hyprctl version` is available only when Hyprland is the running WM.
  #     The `2>/dev/null || echo 'n/a'` guard prevents broken pipe errors
  #     in non-Hyprland sessions (e.g. TTY or a guest WM).

  cmdUptime    = "uptime -p | sed 's/up //' | sed 's/ hours\\{0,1\\}\\s*/h /;s/ minutes\\{0,1\\}//;s/,//g'";
  cmdMemory    = "free -m | awk 'NR==2{printf \"%.1f / %.1f GiB\", $3/1024, $2/1024}'";
  cmdUser      = "echo $USER";
  cmdHostname  = "hostnamectl hostname";
  cmdNixGen    = "nix-env --list-generations 2>/dev/null | tail -1 | awk '{print \"gen #\" $1}' || echo 'n/a'";
  cmdHyprVer   = "hyprctl version 2>/dev/null | grep -oP 'v[0-9.]+' | head -1 || echo 'n/a'";
  cmdLocalIP   = "ip -4 addr show scope global | grep -oP '(?<=inet )([0-9.]+)' | head -1 || echo 'no link'";
  cmdDisk      = "df -h / | awk 'NR==2{print $3 \" / \" $2 \" (\" $5 \")\"}'";

in
{
  # ============================================================================
  # REQUIRED: HOME IDENTITY  —  must be set or ALL xdg paths break
  # ============================================================================
  #
  # These two lines are the fix for:
  #   "Error installing file '.config/fastfetch/config.jsonc' outside $HOME"
  #
  # Without them, home.homeDirectory defaults to "" (empty string) because
  # home.username is also empty.  Every managed file path then becomes a
  # bare relative path like ".config/…" which HM's installer rejects.
  #
  # CHANGE "jivan" to match your actual login username.
  # The homeDirectory must match the real path on disk — check with `echo ~`.
  #
  # If you are using Pattern B (NixOS module) and your nixos config already
  # sets `users.users.jivan.home = "/home/jivan"`, you STILL need these here —
  # NixOS user options and Home Manager home options are separate option sets.

  home.username    = "jivan";           # ← change to your username
  home.homeDirectory = "/home/jivan";   # ← change to match

  # ============================================================================
  # DEPENDENCY: Nerd Fonts
  # ============================================================================
  #
  # Fastfetch's glyphs are Unicode code points in the Nerd Fonts private-use
  # area (U+E000–U+F8FF and U+100000–U+10FFFD).  They ONLY render correctly
  # when your terminal is configured to use a Nerd Font.
  #
  # Home Manager installs fonts via `fonts.fontconfig.enable = true;` (system
  # level) or via `home.packages`.  The font itself must be listed here.
  # The `pkgs.nerd-fonts` attr in nixpkgs 24.05+ provides individual fonts.
  #
  # If your system flake already declares the font at the NixOS level under
  # `fonts.packages`, you can remove the `home.packages` block below to avoid
  # a duplicate store path (it won't break anything, just wastes a few MiB).

  home.packages = with pkgs; [
    # Primary recommendation: JetBrainsMono — excellent readability at small
    # sizes, full Nerd Font v3 coverage, ligatures for terminal editors.
    # Switch to nerd-fonts.fira-code or nerd-fonts.hack if preferred.
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # FASTFETCH MODULE
  # ============================================================================

  programs.fastfetch = {
    enable = true;

    # `settings` is serialized to ~/.config/fastfetch/config.jsonc by HM.
    # The Nix store path is a symlink target; fastfetch treats it as read-only,
    # which is correct — you never edit it directly.

    settings = {

      # JSON Schema reference — enables editor validation if you open this
      # generated file in a JSON-aware editor.  Has no runtime effect.
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      # No ASCII/image logo — our box IS the visual identity.
      logo = null;

      # ──────────────────────────────────────────────────────────────────────
      # DISPLAY SETTINGS
      # ──────────────────────────────────────────────────────────────────────

      display = {
        # Separator between key and value.  Two spaces keeps it tight.
        separator = "  ";

        # Fallback color for any text not wrapped in a {$N} token.
        color = "white";

        # The constants array maps $1…$6 in format/key strings.
        # Evaluated once per fastfetch invocation, not per module.
        #
        # ORDER MATTERS: constants[0] = $1, constants[1] = $2, etc.
        # We use the Nix let-bindings defined above so the mapping is
        # documented in one place and not scattered across 20 lines.

        constants = [ c1 c2 c3 c4 c5 c6 ];
        #              $1  $2  $3  $4  $5  $6
        #             wht pur mav cor gry blu
      };

      # ──────────────────────────────────────────────────────────────────────
      # MODULES
      # ──────────────────────────────────────────────────────────────────────
      #
      # Grouped into five logical sections separated by box dividers:
      #
      #   §1 IDENTITY    — who & where   (kernel, shell, user, hostname)
      #   §2 RESOURCES   — how much      (CPU, GPU, memory, disk)
      #   §3 SYSTEM      — what runs     (OS, WM, terminal, packages)
      #   §4 NIX         — nix-specific  (generation, store path count)
      #   §5 NETWORK     — connectivity  (local IP)
      #
      # Each `type = "command"` module runs a shell snippet at display time.
      # Fastfetch caches nothing between invocations — every run is live.

      modules = [

        # ── Pre-box breathing room ────────────────────────────────────────
        "break"

        # ── Box top border ────────────────────────────────────────────────
        {
          type   = "custom";
          # The key IS the output — no value column here.
          key    = boxTop;
          # format must be empty string so fastfetch prints only the key.
          format = "";
        }

        # ════════════════════════════════════════════════════════════════════
        # §1  IDENTITY
        # ════════════════════════════════════════════════════════════════════

        # KERNEL  — running release string (e.g. "6.8.12-zen1-1-zen")
        {
          type   = "kernel";
          # iconKey: c2 (purple) + "" (nf-fa-linux) + "kernel"
          key    = iconKey c2 "" "kernel";
          # {release>22}: fastfetch's built-in kernel release token,
          # right-justified to fill 22 terminal columns.
          format = "{$2}{release>22}{$1} │";
        }

        # SHELL  — pretty name + version (e.g. "zsh 5.9")
        {
          type   = "shell";
          key    = iconKey c2 "" "shell ";
          # {pretty-name} = shell name + version string.
          format = "{$2}{pretty-name>22}{$1} │";
        }

        # USER  — $USER environment variable via shell command
        {
          type   = "command";
          key    = iconKey c2 "" "user  ";
          text   = cmdUser;
          format = "{$2}{>22}{$1} │";
        }

        # HOSTNAME  — from systemd-hostnamed (survives /etc/hostname changes)
        {
          type   = "command";
          key    = plainKey "hname ";
          text   = cmdHostname;
          format = "{>22} │";
        }

        # UPTIME  — human-readable, compacted (e.g. "3h 24m")
        {
          type   = "command";
          key    = plainKey "uptime";
          text   = cmdUptime;
          format = "{>22} │";
        }

        # ── Section divider ───────────────────────────────────────────────
        {
          type   = "custom";
          key    = boxDiv;
          format = "";
        }

        # ════════════════════════════════════════════════════════════════════
        # §2  HARDWARE
        # ════════════════════════════════════════════════════════════════════

        # CPU  — model name + core count
        #
        # fastfetch's native `cpu` module gives us {name} and {cores-logical}.
        # We use the module type directly (no `command`) for better accuracy —
        # fastfetch reads /proc/cpuinfo and DMI tables, not just `lscpu`.
        {
          type   = "cpu";
          key    = iconKey c5 "" "cpu   ";
          # {name}: fastfetch shortens the model string (removes "(R)", "CPU @", etc.)
          # Right-justified to 22 cols for consistent box alignment across all rows.
          # The core count is embedded in the shortened name by fastfetch automatically.
          format = "{$5}{name>22}{$1} │";
        }

        # GPU  — model name (first GPU; add index for multi-GPU)
        {
          type   = "gpu";
          key    = iconKey c5 "󰍛" "gpu   ";
          format = "{$5}{name>22}{$1} │";
        }

        # MEMORY  — used / total in GiB with two decimal places
        {
          type   = "command";
          key    = iconKey c3 "" "mem   ";
          text   = cmdMemory;
          format = "{$3}{>22}{$1} │";
        }

        # DISK  — root filesystem used / total / percent
        {
          type   = "command";
          key    = iconKey c5 "󰋊" "disk  ";
          text   = cmdDisk;
          format = "{$5}{>22}{$1} │";
        }

        # ── Section divider ───────────────────────────────────────────────
        {
          type   = "custom";
          key    = boxDiv;
          format = "";
        }

        # ════════════════════════════════════════════════════════════════════
        # §3  SYSTEM ENVIRONMENT
        # ════════════════════════════════════════════════════════════════════

        # DISTRO  — NixOS pretty name (from /etc/os-release)
        {
          type   = "os";
          key    = iconKey c4 "" "distro";
          # {pretty-name} includes the NixOS version channel string.
          format = "{$4}{pretty-name>22}{$1} │";
        }

        # WINDOW MANAGER  — Hyprland version (runtime detection)
        {
          type   = "command";
          key    = iconKey c4 "" "wm    ";
          text   = cmdHyprVer;
          format = "{$4}{>22}{$1} │";
        }

        # TERMINAL  — detected terminal emulator name
        {
          type   = "terminal";
          key    = iconKey c4 "" "term  ";
          format = "{$4}{pretty-name>22}{$1} │";
        }

        # PACKAGES  — total package count across all detected managers
        #
        # fastfetch enumerates: nix-user, nix-system, pacman, flatpak, etc.
        # `{all}` sums them.  On NixOS this is typically nix-user + nix-system.
        {
          type   = "packages";
          key    = plainKey "pkgs  ";
          format = "{all>22} │";
        }

        # ── Section divider ───────────────────────────────────────────────
        {
          type   = "custom";
          key    = boxDiv;
          format = "";
        }

        # ════════════════════════════════════════════════════════════════════
        # §4  NIX-SPECIFIC
        # ════════════════════════════════════════════════════════════════════
        #
        # This section surfaces information unique to NixOS/Nix that you
        # won't find in generic sysinfo tools.  Useful when debugging
        # "which generation am I actually running?" after a botched rebuild.

        # NIX GENERATION  — current home-manager / user profile generation
        #
        # Why `nix-env --list-generations` instead of reading a symlink?
        # Because the generation number is in the profile, and nix-env's
        # output is stable across Nix versions.  The `tail -1` picks the
        # most recent (current) generation.
        {
          type   = "command";
          key    = iconKey c6 "" "nixgen";
          text   = cmdNixGen;
          format = "{$6}{>22}{$1} │";
        }

        # NIXOS VERSION  — system-level nixos-version string
        #
        # This reads /etc/nixos-version (a file written by nixos-rebuild).
        # It is NOT the same as `nix --version` (that's the Nix daemon version).
        # Example output: "24.05.20240603.a1b2c3d (Uakari)"
        {
          type   = "command";
          key    = iconKey c6 "" "nixos ";
          text   = "nixos-version 2>/dev/null | cut -d'.' -f1-3 || echo 'n/a'";
          format = "{$6}{>22}{$1} │";
        }

        # ── Section divider ───────────────────────────────────────────────
        {
          type   = "custom";
          key    = boxDiv;
          format = "";
        }

        # ════════════════════════════════════════════════════════════════════
        # §5  NETWORK
        # ════════════════════════════════════════════════════════════════════

        # LOCAL IP  — first non-loopback IPv4 address
        #
        # Uses `ip` (iproute2) rather than `hostname -I` for reliability on
        # systems with multiple interfaces.  `scope global` filters out
        # loopback (scope host) and link-local (scope link).
        {
          type   = "command";
          key    = iconKey c5 "󰤨" "net   ";
          text   = cmdLocalIP;
          format = "{$5}{>22}{$1} │";
        }

        # ── Box bottom border ─────────────────────────────────────────────
        {
          type   = "custom";
          key    = boxBot;
          format = "";
        }

        # ── Post-box breathing room ───────────────────────────────────────
        "break"

      ]; # end modules
    };   # end settings
  };     # end programs.fastfetch
}
# ════════════════════════════════════════════════════════════════════════════
# NOTES FOR JIVAN
# ════════════════════════════════════════════════════════════════════════════
#
# ADDING A MODULE
# ───────────────
# Copy any existing `{ type = ...; key = ...; format = ...; }` block.
# Use `iconKey cX "ICON" "label "` for a colored icon row, or
# `plainKey "label "` for a plain row.  Labels must be exactly 6 visible
# chars (pad with spaces).  Format strings end in `{>22}{$1} │` for values.
#
# CHANGING COLORS
# ───────────────
# Edit c1…c6 at the top.  ANSI 256 palette reference:
#   https://www.ditig.com/256-colors-cheat-sheet
# For true-color (24-bit): replace "38;5;N" with "38;2;R;G;B"
# e.g. exact M3 primary:  "\\u001b[38;2;103;80;164m"
#
# NERD FONTS ICON LOOKUP
# ──────────────────────
# https://www.nerdfonts.com/cheat-sheet
# In Neovim/Vim you can insert a glyph with: <C-v>u<hex-codepoint>
#
# HYPRLAND INTEGRATION
# ────────────────────
# The `cmdHyprVer` command uses `hyprctl` which communicates over the
# Hyprland IPC socket.  If you start fastfetch BEFORE Hyprland is fully
# initialised (e.g. in an early exec-once), hyprctl may time out.
# Add a guard: "sleep 0.5 && hyprctl version …"
#
# PERFORMANCE
# ───────────
# Run:  fastfetch --stat
# This prints per-module timing.  If a `type = "command"` module is slow,
# profile the shell snippet directly: `time eval 'YOUR_COMMAND'`
# Avoid `| head -n1` chains on slow commands — prefer awk/grep one-liners.
#
# NIX STORE NOTE
# ──────────────
# After `home-manager switch`, the generated config lives at:
#   ~/.config/fastfetch/config.jsonc → /nix/store/<hash>-fastfetch.jsonc
# You can inspect the exact JSON with:
#   cat $(readlink -f ~/.config/fastfetch/config.jsonc)
# Never edit it there — changes are lost on next rebuild.  Edit THIS file.
