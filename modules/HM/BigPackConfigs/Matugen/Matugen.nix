{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.matugen.homeManagerModules.default 
  ];

  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";

    templates = {
      foot = {
        # Using ${...} without quotes around the path copies the file to the Nix store
        # and provides the absolute path to the Matugen config.
        input_path = "${./Templates/footTheme.ini}";
        output_path = "${config.xdg.configHome}/foot/theme.ini";
      };
      gtk = {
        input_path = "${./Templates/gtkColors.css}";
        output_path = "${config.xdg.configHome}/gtk-colors/gtkColors.css";
      };
      hypr = {
        input_path = "${./Templates/hypr-colors.lua}";
        output_path = "${config.xdg.configHome}/hypr/scheme/material-you.conf";
      };
      qt = {
        input_path = "${./Templates/qtColors.conf}";
        output_path = "${config.xdg.configHome}/qt5ct/colors/matugen.conf";
      };
      quickshell = {
        input_path = "${./Templates/quickshellColors.js}";
        output_path = "${config.xdg.configHome}/quickshell/Variables/colors.js";
      };
      starship = {
        input_path = "${./Templates/starship.toml}";
        output_path = "${config.xdg.configHome}/starship/starship.toml";
      };
      vscodium = {
        input_path = "${./Templates/vscodium.json}";
        output_path = "${config.xdg.configHome}/vscodium/theme-colors.json";
      };
    };
  };
}