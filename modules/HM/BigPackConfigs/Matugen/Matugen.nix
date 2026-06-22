{ config, pkgs, inputs, ... }: {
  # 1. Install the CLI tool so it's in your PATH
  home.packages = [ inputs.matugen.packages.${pkgs.system}.default ];

  # 2. Copy your templates folder into ~/.config/matugen/templates
  xdg.configFile."matugen/templates".source = ./Templates;

  # 3. Generate the actual config.toml that the CLI relies on
  xdg.configFile."matugen/config.toml".text = ''
    [config]
    variant = "dark"
    json_format = "hex"

    [templates.foot]
    input_path = "${config.xdg.configHome}/matugen/templates/footTheme.ini"
    output_path = "${config.xdg.configHome}/foot/theme.ini"

    [templates.gtk]
    input_path = "${config.xdg.configHome}/matugen/templates/gtkColors.css"
    output_path = "${config.xdg.configHome}/gtk-colors/gtkColors.css"

    [templates.hypr]
    input_path = "${config.xdg.configHome}/matugen/templates/hypr-colors.lua"
    output_path = "${config.xdg.configHome}/hypr/scheme/material-you.conf"

    [templates.qt5]
    input_path = "${config.xdg.configHome}/matugen/templates/qtColors.conf"
    output_path = "${config.xdg.configHome}/qt5ct/colors/matugen.conf"

    [templates.qt6]
    input_path = "${config.xdg.configHome}/matugen/templates/qtColors.conf"
    output_path = "${config.xdg.configHome}/qt6ct/colors/matugen.conf"

    [templates.quickshell]
    input_path = "${config.xdg.configHome}/matugen/templates/quickshellColors.js"
    output_path = "${config.xdg.configHome}/quickshell/Variables/colors.js"

    [templates.starship]
    input_path = "${config.xdg.configHome}/matugen/templates/starship.toml"
    output_path = "${config.xdg.configHome}/starship/starship.toml"

    [templates.vscodium]
    input_path = "${config.xdg.configHome}/matugen/templates/vscodium.json"
    output_path = "${config.xdg.configHome}/vscodium/theme-colors.json"
  '';
}