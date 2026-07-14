{ config, pkgs, lib, inputs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "pixie";
    wayland.enable = true;
    wayland.compositor = "kwin";

    # Crucial for Qt6: Use the KDE/Qt6 build of SDDM to fix missing
    # cursors and module errors.
    package = pkgs.kdePackages.sddm;

    # Make cursor visible on the SDDM login screen
    settings = {
      Theme = {
        CursorTheme = "GoogleDot-Black";
        CursorSize = 24;
      };
      # Pass cursor env vars to the greeter so the theme is picked up
      General = {
        InputMethod = "";
      };
    };

    # Required dependencies for Qt6 themes
    extraPackages = [
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtdeclarative
      pkgs.kdePackages.qt5compat
    ];
  };

  services.displayManager.defaultSession = "hyprland";

  # Ensure SDDM's greeter process can find the cursor theme
  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "GoogleDot-Black";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "/run/current-system/sw/share/icons";
  };

  # Pixie SDDM theme package + cursor for the login screen
  environment.systemPackages = [
    inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm
    pkgs.google-cursor
    pkgs.ddcutil
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.i2c.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
