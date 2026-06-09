{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "";
      };
      modules = [
        {
          type = "custom";
          format = "┌──────────────────────────────────────┐";
        }
        {
          type = "kernel";
          key = "│ kernel  ";
          format = "{2>29}│"; # Outputs clean version numbers (e.g., 7.0.10)
        }
        {
          type = "shell";
          key = "│ shell   ";
          format = "{1>29}│"; # Outputs clean shell name (e.g., fish)
        }
        {
          type = "title";
          key = "│ user    ";
          format = "{1>29}│"; # Outputs clean username
        }
        {
          type = "custom";
          format = "├──────────────────────────────────────┤";
        }
        {
          type = "cpu";
          key = "│ cpu     ";
          format = "{1>29}│";
        }
        {
          type = "gpu";
          key = "│ gpu     ";
          format = "{2>29}│";
        }
        {
          type = "memory";
          key = "│ mem     ";
          format = "{1>29}│";
        }
        {
          type = "disk";
          key = "│ disk    ";
          format = "{1>29}│";
        }
        {
          type = "custom";
          format = "├──────────────────────────────────────┤";
        }
        {
          type = "os";
          key = "│ distro  ";
          format = "{1>29}│"; # Pulls OS name only, stripping out (x86_64) / (Zokor)
        }
        {
          type = "wm";
          key = "│ wm      ";
          format = "{1>29}│"; # Fixes literal printing, outputs clean 'Hyprland'
        }
        {
          type = "terminal";
          key = "│ term    ";
          format = "{1>29}│"; # Outputs clean terminal name (e.g., foot)
        }
        {
          type = "packages";
          key = "│ pkgs    ";
          format = "{1>29}│";
        }
        {
          type = "custom";
          format = "└──────────────────────────────────────┘";
        }
      ];
    };
  };
}