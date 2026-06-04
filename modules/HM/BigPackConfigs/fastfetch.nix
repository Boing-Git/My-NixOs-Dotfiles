{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "  ";
        # Use simple color names instead of raw escape sequences if possible
        color = "white"; 
      };
      modules = [
        "break"
        { type = "custom"; key = "╭───────────────────────────────────╮"; }
        { type = "kernel";  key = "│   kernel│"; }
        { type = "shell";   key = "│   shell │"; }
        { type = "packages"; key = "│   pkgs  │"; }
        { type = "os";      key = "│ 󰻀  distro│"; }
        { type = "custom"; key = "╰───────────────────────────────────╯"; }
      ];
    };
  };
}