{ config, pkgs, lib, ... }:

{
  services.gvfs.enable = true;
  services.usbmuxd.enable = true;
  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
