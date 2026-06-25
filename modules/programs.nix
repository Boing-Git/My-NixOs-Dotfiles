{ config, pkgs, inputs, ... }:

let
  hyprcorners = pkgs.rustPlatform.buildRustPackage rec {
    pname = "hyprcorners";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "ArnoDarkrose";
      repo = "hyprcorners";
      rev = "master";
      hash = "sha256-Wk5lAMmb+caXo8mZTApOpuQia0zEVuZOrhGdL8rUrpQ=";
    };

    cargoHash = "sha256-zQbd1j77kbE+ZJTx7HfnESLrKOy7JVtRYuUSv8iyT7w=";
  };
in

{
  # Install firefox.
  programs.firefox.enable = true;

  # Config Fish
  programs.fish = {
    enable = true;
    shellInit = ''
    set -gx LANG en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
    nitch
    set -g fish_greeting " "
    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
    };
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
    quickshell
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
    tree
    gobject-introspection
    cbonsai
    nitch
    mpvpaper
    lua
    ffmpeg
    fuzzel
    awww
    loupe
    upscayl
    grim
    playerctl
    satty
    github-desktop
    blanket
    virt-manager
    github-cli

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
    (google-fonts.override { fonts = [ "SpaceMono" ]; }) 

    # Upstream Shell Executables from Flake inputs
    inputs.caelestia-shell.packages.${pkgs.system}.with-cli
    inputs.caelestia-cli.packages.${pkgs.system}.default
    inputs.hexecute.packages.${pkgs.system}.default
    # Extract the package directly out of the flake inputs
    inputs.hyprwave.packages.${pkgs.system}.default
    inputs.matugen.packages.${pkgs.system}.default
  ];
}
