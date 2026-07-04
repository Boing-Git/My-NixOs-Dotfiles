{ config, pkgs, inputs, lib, ... }:

{
  programs.firefox.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx LANG en_US.UTF-8
      set -gx LC_ALL en_US.UTF-8
      nitch
      set -g fish_greeting " "
    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer = {
      openFirewall = true;
    };
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vkd3d-proton
      proton-ge-bin
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      xfce = {
        default = [ "gtk" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
    ];
  };

  environment.variables = {
    QT_SCALE_FACTOR = "1";
    GDK_SCALE = "1";
  };
}
