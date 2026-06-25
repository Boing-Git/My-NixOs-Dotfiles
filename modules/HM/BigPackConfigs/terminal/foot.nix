{ config, lib, ... }:

{
  # Foot terminal - main terminal emulator with JetBrains Nerd Font
  programs.foot = {
    enable = true;
    settings = {
      include=~/.config/foot/theme.ini
      main = {
        shell = "fish";
        title = "foot";
        font = "JetBrainsMono Nerd Font:size=11";
        letter-spacing = 0;
        dpi-aware = "no";
        pad = "25x25";
        bold-text-in-bright = "no";
        gamma-correct-blending = "no";
      };
      # How far back I can scroll in the terminal
      scrollback = {
        lines = 10000;
        multiplier = "1.000000";
      };
      # Thin beam cursor instead of block
      cursor = {
        style = "underline";
      };
      # Terminal background transparency
      colors-dark = {
        alpha = "0.78";
      };
      # Scrollback and search shortcuts
      key-bindings = {
        scrollback-up-page = "Page_Up";
        scrollback-down-page = "Page_Down";
        search-start = "Control+Shift+f";
      };
      search-bindings = {
        cancel = "Escape";
        find-prev = "Shift+F3";
        find-next = "F3 Control+G";
      };
    };
  };
}
