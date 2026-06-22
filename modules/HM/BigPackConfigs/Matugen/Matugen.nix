{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.matugen.nixosModules.default 
  ];

  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";

    templates = {
      foot = {
        input_path = "./Templates/footTheme.ini";
        output_path = ".config/foot/theme.ini";
      };
      gtk = {
        input_path = "./Templates/gtkColors.css";
        output_path = ".config/gtk-colors/gtkColors.css";
      };
      hypr = {
        input_path = "./Templates/hypr-colors.lua";
        output_path = ".config/hypr/colors.conf";
      };
      qt = {
        input_path = "./Templates/qtColors.conf";
        output_path = ".config/qt5ct/colors/matugen.conf";
      };
      quickshell = {
        input_path = "./Templates/quickshellColors.js";
        output_path = ".config/quickshell/Variables/colors.js";
      };
      starship = {
        input_path = "./Templates/starship.toml";
        output_path = ".config/starship/starship.toml";
      };
      vscodium = {
        input_path = "./Templates/vscodium.json";
        output_path = ".config/vscodium/theme-colors.json";
      };
    };
  };
}