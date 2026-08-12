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
            # Hold 'alt' for 'control'.
            # Tap 'alt' once to enter the 'alt_double_tap' layer.
            alt = "overload(control, oneshot(alt_double_tap))";

            # Make sure the physical ctrl key acts as the alt modifier layer
            control = "layer(alt)";
          };
          
          alt_double_tap = {
            # Tapping 'alt' a second time acts as the 'meta' (Super/Windows) key
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
