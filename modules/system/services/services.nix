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
              # Hold 'Alt' -> Control
              # Single-tap 'Alt' -> Alt (if no second tap within 200ms)
              # Double-tap 'Alt' -> Super (Meta)
              alt = "overload(control, timeout(alt, 200, oneshot(alt_tap)))";

              # Physical Ctrl key acts as Alt
              control = "alt";
            };

            alt_tap = {
              # Second tap of Alt emits Meta (Super)
              alt = "meta";
            };
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
