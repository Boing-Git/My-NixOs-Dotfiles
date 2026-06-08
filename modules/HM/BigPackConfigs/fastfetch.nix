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
          format = "{2:27}│";
        }
        {
          type = "shell";
          key = "│ shell   ";
          format = "{5:27}│";
        }
        {
          type = "title";
          key = "│ user    ";
          format = "{1:27}│";
        }
        {
          type = "custom";
          format = "├──────────────────────────────────────┤";
        }
        {
          type = "cpu";
          key = "│ cpu     ";
          format = "{1:27}│";
        }
        {
          type = "gpu";
          key = "│ gpu     ";
          format = "{2:27}│";
        }
        {
          type = "memory";
          key = "│ mem     ";
          format = "{1:27}│";
        }
        {
          type = "disk";
          key = "│ disk    ";
          format = "{1:27}│";
        }
        {
          type = "custom";
          format = "├──────────────────────────────────────┤";
        }
        {
          type = "os";
          key = "│ distro  ";
          format = "{2:27}│"; # Pads just 'NixOS' to 27 chars to remove (x86_64)
        }
        {
          type = "wm";
          key = "│ wm      ";
          format = "{1:27}│";
        }
        {
          type = "terminal";
          key = "│ term    ";
          format = "{5:27}│";
        }
        {
          type = "packages";
          key = "│ pkgs    ";
          format = "{1:27}│";
        }
        {
          type = "os";
          key = "│ nixos   ";
          format = "{2} {4:21}│"; # Combines Name + Version to drop (Zokor) cleanly
        }
        {
          type = "custom";
          format = "└──────────────────────────────────────┘";
        }
      ];
    };
  };
}