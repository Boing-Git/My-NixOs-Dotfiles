{ config, pkgs, lib, ... }:

{
  security.polkit.enable = true;
  security.pam.services.system-auth = {};
}
