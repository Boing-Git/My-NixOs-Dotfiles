{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.macAddress = "preserve";
  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.settings = {
    device = {
      "wifi.scan-rand-mac-address" = "no";
    };
    connection = {
      "wifi.bgscan" = "simple:30:-80:86400";
    };
  };
}
