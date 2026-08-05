{ config, pkgs, ... }:

{
  hardware.maccel = {
    enable = true;
    enableCli = true; # Enables command-line tool for runtime parameter adjustment
  };
}
