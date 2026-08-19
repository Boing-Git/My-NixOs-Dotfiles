{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.custom-sunshine;
in {
  options.services.custom-sunshine = {
    enable = lib.mkEnableOption "Sunshine streaming service";
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    environment.systemPackages = [ pkgs.sunshine ];
  };
}
