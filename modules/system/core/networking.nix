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

  networking.firewall = {
    enable = true;
    # Open ports for Sunshine / Moonlight
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPorts = [ 47998 47999 48000 48002 48010 ];
  };
}
