{ pkgs, lib, config, ... }:

let
  # The iconKey helper constructs custom modules keys utilizing fastfetch's dollar-N tokens.
  # Because fastfetch uses '{$N}' syntax, it avoids triggering Nix string interpolation ('${').
  # {$1} will evaluate to the Icon color constant, and {$2} handles the text label color.
  iconKey = icon: text: "{$1}${icon}  {$2}${text}";
in
{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        # Using bare SGR codes here as discovered in your research. 
        # Fastfetch inherently wraps these array elements inside 'ESC[...m'.
        constants = [
          "38;5;141" # {$1} - Icon Color (e.g., Vivid Purple/Mauve)
          "38;5;111" # {$2} - Key Text Color (e.g., Sky Blue)
          "0"        # {$3} - Standard text reset code
        ];
        separator = "   ";
      };

      modules = [
        {
          type = "title";
          keyWidth = 10;
        }
        "break"
        {
          type = "os";
          key = iconKey "" "OS";
        }
        {
          type = "kernel";
          key = iconKey "󰨚" "Kernel";
        }
        {
          type = "uptime";
          key = iconKey "󰅐" "Uptime";
        }
        {
          type = "packages";
          key = iconKey "󰏖" "Packages";
        }
        {
          type = "shell";
          key = iconKey "" "Shell";
        }
        {
          type = "display";
          key = iconKey "󰍹" "Display";
        }
        {
          type = "de";
          key = iconKey "󰇄" "DE/WM";
        }
        {
          type = "terminal";
          key = iconKey "" "Terminal";
        }
        {
          type = "cpu";
          key = iconKey "󰍛" "CPU";
        }
        {
          type = "gpu";
          key = iconKey "󰢮" "GPU";
        }
        {
          type = "memory";
          key = iconKey "" "Memory";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}