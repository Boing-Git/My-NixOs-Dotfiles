{ config, pkgs, ... }:
let
  caelestia-sddm-locklike = pkgs.stdenv.mkDerivation {
    name = "caelestia-sddm-locklike";
    src = pkgs.fetchFromGitHub {
      owner = "ItsABigIgloo";
      repo  = "caelestia-sddm";
      rev   = "main";   # use "main" not "master" — that's the actual default branch
      sha256 = "sha256-/fUG5xt6Drz8o1cwDbYCMkac5X6hDmieQ02GFSzjNuU=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Only install the Locklike theme subdirectory, not the whole repo.
      # The repo ships its own metadata.desktop — use it, don't overwrite.
      mkdir -p $out/share/sddm/themes
      cp -aR themes/Locklike $out/share/sddm/themes/Locklike

      runHook postInstall
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable   = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams   = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Display Manager ───────────────────────────────────────────────────────
  services.displayManager = {
    defaultSession = "hyprland";

    sddm = {
      enable  = true;
      # CRITICAL: explicitly use the Qt6 kdePackages build of SDDM.
      # Without this, wayland.enable = true will either fail or use a
      # mismatched sddm binary that can't load Qt6 themes properly.
      package = pkgs.kdePackages.sddm;
      theme   = "Locklike";

      wayland.enable = true;

      extraPackages = [
        caelestia-sddm-locklike

        # Qt6 runtime deps for a Wayland SDDM theme
        pkgs.kdePackages.qt5compat          # QML QtGraphicalEffects compat layer
        pkgs.kdePackages.qtsvg              # SVG icon rendering
        pkgs.kdePackages.qtdeclarative      # QML engine
        pkgs.kdePackages.qtwayland          # Wayland platform plugin
        pkgs.kdePackages.qqc2-desktop-style # QQC2 controls styling
        pkgs.kdePackages.breeze-icons       # fallback icon theme
        pkgs.kdePackages.qtmultimedia       # needed if theme uses video/blur
      ];
    };
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────────
  time.timeZone     = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Graphics / Nvidia ─────────────────────────────────────────────────────
  services.xserver.enable = true;
  hardware.graphics = {
    enable    = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable  = true;
    powerManagement.enable = false;
    open            = false;
    nvidiaSettings  = true;
    package         = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # ── System Environment ────────────────────────────────────────────────────
  environment.systemPackages = [
    pkgs.git
    caelestia-sddm-locklike  # must be here AND in extraPackages
    pkgs.kdePackages.kate
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS   = "1";
    NIXOS_OZONE_HWP           = "1";
    GBM_BACKEND               = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME         = "nvidia";
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users."boing" = {
    shell        = pkgs.fish;
    isNormalUser = true;
    description  = "Boing";
    extraGroups  = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input" ];
  };

  # ── Fonts ─────────────────────────────────────────────────────────────────
  # Locklike theme requires: material-symbols (rounded variant), rubik, roboto.
  # caskaydia-cove is the CORRECT nerd-fonts attribute name (not cascadia-code).
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove   # patched Cascadia Code — correct Nixpkgs attr
    material-symbols            # provides the rounded icons Locklike needs
    roboto
    rubik
    # Do NOT use pkgs.google-fonts — it's a massive package (100+ fonts).
    # Add only what you need specifically.
  ];

  # ── Misc ──────────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;
  services.printing.enable   = true;
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  system.stateVersion = "26.05";
}