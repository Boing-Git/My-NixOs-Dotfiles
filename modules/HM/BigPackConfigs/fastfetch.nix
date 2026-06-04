# fastfetch.nix
# Home Manager module for Fastfetch configuration.
# Drop-in for your home.nix imports or a dedicated programs/ directory.
#
# Usage:
#   imports = [ ./fastfetch.nix ];
#
# Why home.file + builtins.toJSON?
#   Fastfetch reads a plain JSON file from ~/.config/fastfetch/config.jsonc.
#   Home Manager's programs.fastfetch.settings writes the same structure, but
#   going through home.file with builtins.toJSON gives you:
#     • Full control over key ordering (matters for the box-drawing layout).
#     • No dependency on the programs.fastfetch module being available in your
#       nixpkgs version.
#     • The rendered file is a read-only symlink into the Nix store, so it is
#       immutable and garbage-collection safe — exactly what you want.

{ config, lib, pkgs, ... }:

let
  # ── ANSI escape sequences ────────────────────────────────────────────────
  # Nix string literals cannot contain raw ESC (\x1b) directly; use the
  # Unicode escape \u001b, which Nix's string handling passes through intact
  # when serialised by builtins.toJSON.
  esc     = "\u001b";          # ESC / \033
  reset   = "${esc}[37m";      # $1 – white  (used as reset-to-default here)
  black16 = "${esc}[38;5;16m"; # $2 – xterm colour 16  (deep black)
  black17 = "${esc}[38;5;17m"; # $3 – xterm colour 17
  black18 = "${esc}[38;5;18m"; # $4 – xterm colour 18

  # ── Config structure (mirrors the original JSON 1-to-1) ─────────────────
  fastfetchConfig = {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    # null → no logo printed
    logo = null;

    display = {
      separator = "  ";
      color     = "white";
      # The four colour constants referenced as {$1}…{$4} in key/format strings
      constants = [ reset black16 black17 black18 ];
    };

    modules = [
      # ── blank line ────────────────────────────────────────────────────────
      "break"

      # ── top border ────────────────────────────────────────────────────────
      {
        type = "custom";
        key  = "╭───────────────────────────────────╮";
      }

      # ── kernel ────────────────────────────────────────────────────────────
      # {release>22} right-aligns the kernel release string in a 22-char field.
      {
        type   = "kernel";
        key    = "│ {$2}{$1}  kernel";
        format = "{$2}{release>22}{$1} │";
      }

      # ── uptime ────────────────────────────────────────────────────────────
      # `uptime -p` → "up 3 hours, 12 minutes"; cut removes the leading "up ".
      {
        type   = "command";
        key    = "│   uptime";
        text   = "uptime -p | cut -d ' ' -f 2-";
        format = "{>22} │";
      }

      # ── shell ─────────────────────────────────────────────────────────────
      {
        type   = "shell";
        key    = "│ {$2}{$1}  shell ";
        format = "{$2}{pretty-name>22}{$1} │";
      }

      # ── memory ────────────────────────────────────────────────────────────
      # awk prints "used GiB / total GiB" from the second line of `free -m`.
      {
        type   = "command";
        key    = "│ {$3}{$1}  mem   ";
        text   = "free -m | awk 'NR==2{printf \"%.2f GiB / %.2f GiB\",$3/1024,$2/1024}'";
        format = "{$3}{>22}{$1} │";
      }

      # ── packages ──────────────────────────────────────────────────────────
      # {all} sums every package manager fastfetch detects (nix, pacman, etc.)
      {
        type   = "packages";
        key    = "│   pkgs  ";
        format = "{all>22} │";
      }

      # ── user ──────────────────────────────────────────────────────────────
      {
        type   = "command";
        key    = "│ {$2}{$1}  user  ";
        text   = "echo $USER";
        format = "{$2}{>22}{$1} │";
      }

      # ── hostname ──────────────────────────────────────────────────────────
      {
        type   = "command";
        key    = "│   hname ";
        text   = "hostnamectl hostname";
        format = "{>22} │";
      }

      # ── distro ────────────────────────────────────────────────────────────
      # 󰻀 is the NixOS Nerd Font glyph (U+F08C0).
      {
        type   = "os";
        key    = "│ {$4}󰻀{$1}  distro";
        format = "{$4}{pretty-name>22}{$1} │";
      }

      # ── bottom border ─────────────────────────────────────────────────────
      {
        type = "custom";
        key  = "╰───────────────────────────────────╯";
      }

      # ── blank line ────────────────────────────────────────────────────────
      "break"
    ];
  };

in
{
  # ── Package ──────────────────────────────────────────────────────────────
  # Ensures `fastfetch` is on PATH; remove if you manage it elsewhere.
  home.packages = [ pkgs.fastfetch ];

  # ── Config file ──────────────────────────────────────────────────────────
  # builtins.toJSON serialises the Nix attrset to a valid JSON string.
  # The result is written into the Nix store and symlinked at the XDG path.
  # `force = true` lets Home Manager overwrite a pre-existing (non-managed)
  # file during the first activation — remove if you prefer a hard error.
  home.file.".config/fastfetch/config.jsonc" = {
    text  = builtins.toJSON fastfetchConfig;
    force = true;
  };
}
