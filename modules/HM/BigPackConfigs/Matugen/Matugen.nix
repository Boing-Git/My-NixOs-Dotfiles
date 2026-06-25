{ config, pkgs, inputs, ... }: {
  home.packages = [ inputs.matugen.packages.${pkgs.system}.default ];

  # Force the creation of the config file without managing the entire directory
  home.file.".config/matugen/config.toml" = {
    force = true; 
    text = ''
      [config]
      variant = "dark"
      json_format = "hex"

      [templates.hypr]
      input_path = "${config.xdg.configHome}/matugen/templates/hypr-colors.lua"
      output_path = "${config.xdg.configHome}/hypr/scheme/material-you.lua"


      [templates.foot]
      input_path = "${config.xdg.configHome}/matugen/templates/footTheme.ini"
      output_path = "${config.xdg.configHome}/foot/theme.ini"

      [templates.gtk]
      input_path = "${config.xdg.configHome}/matugen/templates/gtkColors.css"
      output_path = "${config.xdg.configHome}/gtk-colors/gtkColors.css"

      [templates.hypr]
      input_path = "${config.xdg.configHome}/matugen/templates/hypr-colors.lua"
      output_path = "${config.xdg.configHome}/hypr/scheme/material-you.lua"

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
      output_path = "${config.xdg.configHome}/starship.toml"

      [templates.vscodium]
      input_path = "${config.xdg.configHome}/matugen/templates/vscodium.json"
      output_path = "${config.xdg.configHome}/vscodium/theme-colors.json"
    '';
  };
}