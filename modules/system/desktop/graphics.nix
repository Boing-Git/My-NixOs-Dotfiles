{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
