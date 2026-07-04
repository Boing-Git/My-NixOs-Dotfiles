{ config, pkgs, lib, ... }:

{
  # ── Greeter (greetd + quickshell) ──────────────────────────────────────
  environment.etc."quickshell-greeter/shell.qml".source =
    /home/boing/.config/quickshell/greeter/shell.qml;
  environment.etc."quickshell-greeter/LoginCard.qml".source =
    /home/boing/.config/quickshell/greeter/LoginCard.qml;
  environment.etc."quickshell-greeter/Variables/Theme.qml".source =
    /home/boing/.config/quickshell/greeter/Variables/Theme.qml;
  environment.etc."quickshell-greeter/Variables/variables.js".source =
    /home/boing/.config/quickshell/greeter/Variables/variables.js;

  environment.etc."quickshell-greeter/hyprland.conf".text = ''
    exec-once = ${pkgs.quickshell}/bin/quickshell -c /etc/quickshell-greeter
    
    animations {
        enabled = false
    }
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_autoreload = true
    }
  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config /etc/quickshell-greeter/hyprland.conf";
        user = "greeter";
      };
    };
  };

  # Suppress greetd's TTY text so only the graphical greeter shows
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
