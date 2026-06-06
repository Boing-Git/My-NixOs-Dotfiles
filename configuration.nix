{ config, pkgs, ... }:

let
  caelestia-sddm-locklike = pkgs.stdenv.mkDerivation {
    name = "caelestia-sddm-locklike";
    src = pkgs.fetchFromGitHub {
      owner = "ItsABigIgloo";
      repo = "caelestia-sddm";
      rev = "master";
      sha256 = "sha256-/fUG5xt6Drz8o1cwDbYCMkac5X6hDmieQ02GFSzjNuU=";
    };
    dontBuild = true;
    installPhase = ''
      # Create the destination directory
      mkdir -p $out/share/sddm/themes/Locklike
      
      # Copy contents of the 'Locklike' folder from the source to the output
      # Use the source root (which is usually '.')
      cp -aR Locklike/. $out/share/sddm/themes/Locklike/
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Display Manager Configuration
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      # Using Wayland is recommended for modern themes
      wayland.enable = true; 
      theme = "Locklike";
      # You must add the theme to extraPackages so SDDM can find the files
      extraPackages = [
        caelestia-sddm-locklike
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtdeclarative
      ];
    };
  };

  networking.hostName = "nixos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Graphics/Nvidia
  services.xserver.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # System Environment
  environment.systemPackages = [ 
    pkgs.git
    caelestia-sddm-locklike # Also available in system path
    pkgs.kdePackages.kate 
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_HWP = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # Users
  users.users."boing" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Boing";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input" ];
  };

  # Fonts & Misc
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono google-fonts ];
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  system.stateVersion = "26.05";
}