{ config, pkgs, ... }:

let
  caelestia-sddm-locklike = pkgs.stdenv.mkDerivation {
    pname   = "caelestia-sddm-locklike";
    version = "unstable-2024";

    src = pkgs.fetchFromGitHub {
      owner  = "ItsABigIgloo";
      repo   = "caelestia-sddm";
      rev    = "main";
      # If hash mismatches run:
      #   nix-prefetch-github ItsABigIgloo caelestia-sddm --rev main
      # and paste the output here.
      sha256 = "sha256-/fUG5xt6Drz8o1cwDbYCMkac5X6hDmieQ02GFSzjNuU=";
    };

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes/Locklike
      cp -aR themes/locklike/. $out/share/sddm/themes/Locklike/

      runHook postInstall
    '';
  };

in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams                    = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages                  = pkgs.linuxPackages_latest;

  # ── Display Manager ───────────────────────────────────────────────────
  services.displayManager = {
    defaultSession = "hyprland";

    # Forces SDDM to always launch Hyprland for boing without showing
    # the session picker. Remove these two lines if you ever want to
    # choose a different session at the login screen.
    autoLogin.enable = true;
    autoLogin.user   = "boing";

    sddm = {
      enable         = true;
      package        = pkgs.kdePackages.sddm;
      wayland.enable = true;
      theme          = "Locklike";

      extraPackages = [
        caelestia-sddm-locklike
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.qtwayland
        pkgs.kdePackages.qqc2-desktop-style
        pkgs.kdePackages.breeze-icons
        pkgs.kdePackages.qtmultimedia
      ];
    };
  };

  # ── Networking ────────────────────────────────────────────────────────
  networking.hostName                 = "nixos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable    = true;
  hardware.bluetooth.enable           = true;

  # ── Locale & Time ─────────────────────────────────────────────────────
  time.timeZone      = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Graphics / Nvidia ─────────────────────────────────────────────────
  services.xserver.enable = true;

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable     = true;
    powerManagement.enable = false;
    open                   = false;
    nvidiaSettings         = true;
    # Using 'production' branch to match current system-wide drivers
    package                = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ── Session Variables ─────────────────────────────────────────────────
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS   = "1";
    NIXOS_OZONE_HWP           = "1";
    GBM_BACKEND               = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME         = "nvidia";
  };

  # ── System Packages ───────────────────────────────────────────────────
  environment.systemPackages = [
    pkgs.git
    caelestia-sddm-locklike
    pkgs.kdePackages.kate
  ];

  # ── Users ─────────────────────────────────────────────────────────────
  users.users."boing" = {
    shell        = pkgs.fish;
    isNormalUser = true;
    description  = "Boing";
    extraGroups  = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input" ];
  };

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    material-symbols
    rubik
    roboto
  ];

  # ── Misc ──────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;
  services.printing.enable   = true;

  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  # Inside your system-wide configuration.nix
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.udev.extraRules = ''
  # Disable USB autosuspend for the TUF GAMING M3 Mouse
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1910", ATTR{power/control}="on"

  # Optional: If it still disconnects, the Hub itself might be the issue.
  # This targets the QinHeng USB Hub as well:
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="8095", ATTR{power/control}="on"
  '';

  system.stateVersion = "26.05";
}