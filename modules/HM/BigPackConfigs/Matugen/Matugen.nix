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
        input_path = "${config.xdg.configHome}/matugen/Templates/footTheme.ini";
        output_path = "${config.xdg.configHome}/foot/theme.ini";
      };
      quickshell = {
        input_path = "${config.xdg.configHome}/matugen/Templates/quickshellColors.js";
        output_path = "${config.xdg.configHome}/quickshell/Colors/colors.js";
      };
    };
  };
}