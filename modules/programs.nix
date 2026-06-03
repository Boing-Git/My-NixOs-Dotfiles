{ config, pkgs, inputs, ... }:

{
  # Enable the Hyprland window manager
  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    vscodium
    foot
    papirus-folders
    papirus-icon-theme
    nautilus
    spotify
    jq
    btop

    # Core Build & Framework Tools
    cmake
    ninja
    pkg-config
    qt6.qtbase
    qt6.qtdeclarative
    qt6.wrapQtAppsHook

    # System & Hardware Control Tools
    ddcutil
    brightnessctl
    lm_sensors
    networkmanager
    pipewire

    # Shell Environments & Utilities
    fish
    bash
    app2unit
    swappy
    wl-clipboard
    libqalculate

    # Audio & Visual Processing Libraries
    aubio
    libcava
    fftw
    xkeyboard-config

    # Typography & Styling Assets
    material-symbols
    rubik
    nerd-fonts.caskaydia-cove

    # Upstream Shell Executables from Flake inputs
    inputs.caelestia-shell.packages.${pkgs.system}.with-cli
    inputs.caelestia-cli.packages.${pkgs.system}.default
  ];
}
