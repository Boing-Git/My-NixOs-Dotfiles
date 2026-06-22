{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.matugen.homeManagerModules.default
  ];

  programs.matugen = {
    enable = true;
    
    # 1. Provide the path to your wallpaper file right here
    wallpaper = /home/boing/Pictures/Wallpapers/abstract/a_black_and_white_drawing_of_a_person_with_a_blindfold.png;

    # 2. Top-level options use camelCase instead of snake_case
    variant = "dark"; 
    jsonFormat = "hex"; 

    # 3. Define templates directly here (Notice inputPath and outputPath)
    templates = {
      foot = {
        inputPath = ./Templates/footTheme.ini;
        outputPath = "${config.xdg.configHome}/foot/theme.ini";
      };
      quickshell = {
        inputPath = ./Templates/quickshellColors.js;
        outputPath = "${config.xdg.configHome}/quickshell/Colors/colors.js";
      };
    };
  };
}