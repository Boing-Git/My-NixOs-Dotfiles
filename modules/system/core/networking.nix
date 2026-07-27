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
      # Disable background Wi-Fi scans and power saving to prevent radio channel hopping and ping spikes
      "wifi.bgscan" = "";
      "wifi.powersave" = 2;
    };
  };
}
