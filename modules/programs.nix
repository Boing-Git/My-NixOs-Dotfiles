{ config, pkgs, inputs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  # Config Fish
  programs.fish = {
    enable = true;
    shellInit = ''
    set -gx LANG en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
    fastfetch
    set -g fish_greeting "
    /-_-_-_-_-_-_-_-\
    \-_-_-_-_-_-_-_-/
    "
    '';
  };
  
  # Config hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer = {
        openFirewall = true;
      };
    # Correct packages for Nvidia hardware acceleration inside Steam FHS
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vkd3d-proton         # Correct package r DX12 to Vulkan translation
      proton-ge-bin        # (Optional but recommended) includes built-in NVAPI fixes
    ];
  };


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    hyperhdr
    git
    vscodium
    foot
    papirus-folders
    papirus-icon-theme
    nautilus
    spotify
    jq
    btop
    eza
    zoxide
    nerd-fonts.jetbrains-mono
    wl-clipboard
    cliphist
    xdg-utils
    gtk3
    desktop-file-utils
    cairo
    pango
    gobject-introspection

    (python3.withPackages (ps: with ps; [
      tkinter
      pygobject3
      pywebview
      flask
    ]))

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
