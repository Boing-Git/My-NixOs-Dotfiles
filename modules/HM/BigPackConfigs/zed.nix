{ pkgs, ... }:

{
  # Zed - Caelestia Shell Development Configuration
  programs.zed-editor = {
    enable = true;

    # Pre-load required ecosystem extensions
    extensions = [
      "nix"              # Nix language server integration
      "qml"              # Qt Modeling Language support for shell components
    ];

    # Core settings.json translation
    userSettings = {
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "CaskaydiaCove Nerd Font";
      multi_cursor_modifier = "cmd_or_ctrl";

      theme = {
        mode = "system";
        light = "One Light";
        dark = "One Dark";
      };

      # Per-language definitions
      languages = {
        Nix = {
          language_servers = [ "nixd" "!nil" ];
        };
        QML = {
          formatter = {
            external = {
              command = "sh";
              arguments = [
                "-c"
                "tmp=$(mktemp --suffix .qml); cat > $tmp; qmlformat $tmp"
              ];
            };
          };
        };
      };

      # Language Server Protocol parameters
      lsp = {
        nixd = {
          settings = {
            nixpkgs = {
              expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}";
            };
            formatting = {
              command = [ "alejandra" ];
            };
          };
        };
        qml = {
          binary = {
            arguments = [ "-E" ];
          };
        };
      };
    };

    # Core keymap.json translation
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-shift-up" = "editor::MoveLineUp";
          "ctrl-shift-down" = "editor::MoveLineDown";
          "alt-down" = [ "editor::SelectNext" { replace_newest = false; } ];
          "alt-up" = [ "editor::SelectPrevious" { replace_newest = false; } ];
        };
      }
    ];
  };
}