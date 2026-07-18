{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  networking.networkmanager.wifi.powersave = false;
  hardware.enableRedistributableFirmware = true;
}
