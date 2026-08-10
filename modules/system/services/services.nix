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
              # Hold 'alt' to act as 'meta' (Super).
              # Tap 'alt' once to briefly enter the 'alt_double_tap' layer.
              alt = "overload(meta, oneshot(alt_double_tap))";
            };
            
            alt_double_tap = {
              # What happens when you hit 'alt' a second time:
              # layer(control) means you tap once, then press and hold the second time to act as Control.
              alt = "layer(control)"; 
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
