{ config, pkgs, lib, ... }:

let
  cfg = config.services.custom-sunshine;
in {
  options.services.custom-sunshine = {
    enable = lib.mkEnableOption "Sunshine streaming service";
  };

  config = {
    services.gvfs.enable = true;
    services.usbmuxd.enable = true;
    security.polkit.enable = true;
    programs.coolercontrol.enable = true;

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              # Hold 'alt' to act as 'control'.
              # Tap 'alt' once to briefly enter the 'alt_double_tap' layer.
              alt = "overload(control, oneshot(alt_double_tap))";

              # Make sure the ctrl key becomes the alt key
              control = "layer(alt)";
            };
            
            alt_double_tap = {
              # What happens when you hit 'alt' a second time:
              # Act as 'meta' (Super)
              alt = "meta"; 
            };
          };
        };
      };
  };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    services.sunshine = lib.mkIf cfg.enable {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
