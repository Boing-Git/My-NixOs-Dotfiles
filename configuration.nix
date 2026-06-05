# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  caelestia-sddm-locklike = pkgs.stdenv.mkDerivation {
    name = "caelestia-sddm-locklike";
    src = pkgs.fetchFromGitHub {
      owner = "ItsABigIgloo";
      repo = "caelestia-sddm";
      rev = "master";
      sha256 = "sha256-/fUG5xt6Drz8o1cwDbYCMkac5X6hDmieQ02GFSzjNuU=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/Locklike
      # Copy the contents of the repo directly into the Locklike theme folder
      cp -aR ./. $out/share/sddm/themes/Locklike

      # Generate the explicit Qt6 metadata declaration required by modern SDDM
      cat <<EOF > $out/share/sddm/themes/Locklike/metadata.desktop
      [Desktop Entry]
      Name=Locklike
      Type=sddm-theme
      ConfigFile=theme.conf
      QtVersion=6
      EOF
    '';
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/programs.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Display Manager Configuration
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    # Point to the string name of the theme directory.
    theme = "Locklike";

    # REMOVED: kdePackages.qtgraphicaleffects (Obsolete in Qt6/KDE6)
    extraPackages = with pkgs; [
      kdePackages.qt5compat
      kdePackages.qtsvg
      kdePackages.qtdeclarative
    ];
  };

  networking.hostName = "nixos"; # Define your hostname.

  hardware.steam-hardware.enable = true;

  # Nix experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gnome.core-apps.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    caelestia-sddm-locklike # FIX 3: Global registration so SDDM can locate the assets in the system path
  ];

  # FIX 4: Nvidia + Wayland Environment Variables to prevent Hyprland black screen crashes
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_HWP = "1"; # Forces electron apps like VS Code/Discord to run natively on Wayland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  system.activationScripts.papirusFolders = {
    text = "true";
    deps = [];
  };

  # Define a user account.
  users.users."boing" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Boing";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    google-fonts
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nvidia Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Critical for 32-bit apps and gaming UI layers
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # Proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaPersistenced = true;
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 5353 4048 ];
  };

  system.stateVersion = "26.05"; 
}