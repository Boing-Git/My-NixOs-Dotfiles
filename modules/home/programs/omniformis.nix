{ config, pkgs, lib, ... }:

{
  programs.omniformis = {
    enable = true;
    quickshell.enable = true;
    hyprland.enable = true;
    wezterm.enable = true;
    fish.enable = true;
    btop.enable = true;
    cava.enable = true;
    nvim.enable = true;
    nvtop.enable = true;
    fastfetch.enable = true;
    qt5ct.enable = true;
    qt6ct.enable = true;
    nwg-look.enable = true;
    starship.enable = true;
    color-schemes.enable = true;
    matugen.enable = true;
    qtengine.enable = true;
  };
}
