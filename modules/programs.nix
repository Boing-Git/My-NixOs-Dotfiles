{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

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
  programs.virt-management = {
    enable = false;
  };
  services.surinder-setup.enable = lib.mkDefault false;

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
      vkd3d-proton # Correct package r DX12 to Vulkan translation
      proton-ge-bin # (Optional but recommended) includes built-in NVAPI fixes
    ];
  };

  xdg.portal = {
    enable = true;
    # Ensure both backends are available on the system
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    # Map the portals to the specific desktop environments
    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      xfce = {
        default = [ "gtk" ];
      };
      # A safe fallback for any session that isn't explicitly named
      common = {
        default = [ "gtk" ];
      };
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      # Add the missing context menu plugin
      thunar-archive-plugin
    ];
  };

  environment.variables = {
    QT_SCALE_FACTOR = "1";
    GDK_SCALE = "1";
  };

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting.enable = true;
    hinting.style = "slight";
    subpixel.rgba = "rgb"; # Matches standard LCD/Retina pixel layouts
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    quickshell
    hyperhdr
    git
    vscodium
    wezterm
    nerd-fonts.space-mono
    papirus-folders
    papirus-icon-theme
    nautilus
    file-roller # Add the archive manager backend
    (pkgs.spotify.override {
      deviceScaleFactor = 1.0;
    })
    jq
    btop
    eza
    zoxide
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
    github-cli
    nixfmt # Official standard formatter
    nixd # Highly recommended Language Server (LSP)
    antigravity

    # Generate a secondary desktop entry for the scaled version
    # This guarantees BOTH "Antigravity" and "Antigravity (Scaled)" appear in the menu
    (pkgs.runCommand "antigravity-scaled-desktop" { } ''
      mkdir -p $out/share/applications
      cp ${pkgs.antigravity}/share/applications/antigravity.desktop $out/share/applications/antigravity-scaled.desktop
      sed -i 's/^Name=Antigravity/Name=Antigravity (Scaled)/' $out/share/applications/antigravity-scaled.desktop
      sed -i 's|^Exec=antigravity|Exec=antigravity --force-device-scale-factor=2|g' $out/share/applications/antigravity-scaled.desktop
    '')
    hypridle

    (python3.withPackages (
      ps: with ps; [
        tkinter
        pygobject3
        pywebview
        flask
      ]
    ))

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

    inputs.hexecute.packages.${pkgs.system}.default
    inputs.matugen.packages.${pkgs.system}.default
  ];
}
