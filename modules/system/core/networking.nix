{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
}
