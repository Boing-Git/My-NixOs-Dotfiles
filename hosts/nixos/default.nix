{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core/boot.nix
    ../../modules/system/core/networking.nix
    ../../modules/system/core/users.nix
    ../../modules/system/core/environment.nix
    ../../modules/system/desktop/fonts.nix
    ../../modules/system/desktop/greetd.nix
    ../../modules/system/desktop/graphics.nix
    ../../modules/system/services/services.nix
    ../../modules/system/services/surinder-setup.nix
    ../../modules/system/services/virt-management.nix
    ../../modules/system/programs/packages.nix
    ../../modules/system/programs/default.nix
  ];

  services.surinder-setup.enable = lib.mkForce true;
  programs.virt-management.enable = false;
}
