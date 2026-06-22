{ config, pkgs, inputs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = [
    inputs.matugen.packages.${pkgs.system}.default
  ];

  # 1. THIS IS THE MISSING PIECE: Copy your Templates folder into ~/.config/matugen/Templates
  xdg.configFile."matugen/Templates".source = ./Templates;

  xdg.configFile."matugen/config.toml".source = tomlFormat.generate "matugen-config" {
    config = {
      variant = "dark";
      json_format = "hex";
    };

    templates = {
      foot = {
        input_path = "./Templates/footTheme.ini";
        output_path = "${config.xdg.configHome}/foot/theme.ini";
      };
      quickshell = {
        input_path = "./Templates/quickshellColors.js";
        output_path = "${config.xdg.configHome}/quickshell/Variables/colors.js";
      };
      gtk = {
        input_path = "./Templates/gtkColors.css"
        output_path = "${config.xdg.configHome}/gtk-colors/gtkColors.css"
      };
      # Qt5 Configuration Output
      qt5ct-colors = {
        input_path = ./templates/qtct.conf;
        output_path = "${config.xdg.configHome}/qt5ct/colors/matugen.conf";
      };
      
      # Qt6 Configuration Output
      qt6ct-colors = {
        input_path = ./templates/qtct.conf;
        output_path = "${config.xdg.configHome}/qt6ct/colors/matugen.conf";
      };

      starship = {
        input_path = ./Templates/starship.toml;
        output_path = "${config.xdg.configHome}/starship/starship.toml"
      }
    };
  };
}