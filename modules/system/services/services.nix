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
            alt = "overload(control, oneshot(alt_double_tap))";
            control = "alt";  # not layer(alt) — see below
          };

          alt_double_tap = {
            alt = "oneshot(meta)";
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

    services.auto-cpufreq.enable = true;

    services.sunshine = lib.mkIf cfg.enable {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
