{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.matugen.homeManagerModules.default
  ];

  programs.matugen = {
    enable = true;
    
    settings = {
      config = {
        variant = "dark"; 
        json_format = "hex"; 
        reload_apps = true; # Handles built-in supported apps automatically
      };

      templates = {
        foot = {
          input_path = ./Templates/footTheme.ini;
          output_path = "${config.xdg.configHome}/foot/theme.ini";
          # Optional: If foot doesn't auto-reload, you can force it here:
          # post_cmd = "footclient -c ${config.xdg.configHome}/foot/foot.ini";
        };
        quickshell = {
          input_path = ./Templates/quickshellColors.js;
          output_path = "${config.xdg.configHome}/quickshell/Colors/colors.js";
        };
      };
    };
  };
}