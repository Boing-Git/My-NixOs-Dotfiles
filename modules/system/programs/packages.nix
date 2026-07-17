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

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    quickshell
    hyperhdr
    git
    vscodium
    wezterm
    nerd-fonts.space-mono
    (papirus-icon-theme.override { color = "brown"; })
    nautilus
    file-roller
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
    lua
    ffmpeg
    awww
    loupe
    upscayl
    grim
    playerctl
    satty
    github-desktop
    blanket
    github-cli
    nixfmt
    nixd
    antigravity
    vlc
    obs-studio
    losslesscut
    handbrake

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
        emoji
      ]
    ))

    cmake
    ninja
    pkg-config
    qt6.qtbase
    qt6.qtdeclarative
    qt6.wrapQtAppsHook

    ddcutil
    brightnessctl
    lm_sensors
    networkmanager
    pipewire

    fish
    bash
    app2unit
    swappy
    wl-clipboard
    libqalculate

    aubio
    libcava
    fftw
    xkeyboard-config

    material-symbols
    rubik
    nerd-fonts.caskaydia-cove
    (google-fonts.override { fonts = [ "SpaceMono" ]; })

    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
