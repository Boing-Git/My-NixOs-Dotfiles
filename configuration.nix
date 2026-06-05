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

  services.displayManager.sddm = {
    enable = true;
    # Force Wayland backend instead of X11 if you prefer
    wayland.enable = true; 
    # Point the theme path directly to the built derivation folder
    theme = "${caelestia-sddm-locklike}/share/sddm/themes/Locklike";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.steam-hardware.enable = true;

  #Nix experimental features 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # 1. Fix the Graphics crash (glXChooseVisual and Vulkan errors)
  hardware.graphics = {
    # CRITICAL: Installs 32-bit drivers so Steam can draw its UI
    enable32Bit = true; 
  };

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
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # System requirements and user applications
  environment.systemPackages = with pkgs; [
    git
  ];

  system.activationScripts.papirusFolders = {
    text = "true";
    deps = [];
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."boing" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Boing";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input"];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Add this to configuration.nix to ensure fonts are globally recognized
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    google-fonts
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # Proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaPersistenced = true;
  };
  
  # Ensure the proprietary driver is explicitly chosen
  services.xserver.videoDrivers = [ "nvidia" ];

  # Ensure hardware graphics are fully enabled
  hardware.graphics.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 5353 4048 ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}