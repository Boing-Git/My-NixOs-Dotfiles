{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
    ./virt-management.nix
    ./surinder-setup.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Display Manager ───────────────────────────────────────────────────
  services.displayManager = {
    defaultSession = "hyprland";

    # Temporarily disabled to allow testing XFCE for surinder
    autoLogin.enable = false;
    autoLogin.user = "boing";

    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # ── Networking ────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    cores = 0;
    max-jobs = "auto";
    http-connections = 50;
    auto-optimise-store = true;
  };
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Graphics / Nvidia / Desktop Managers ──────────────────────────────
  services.xserver.enable = true;

  # ── Desktop Environments ──────────────────────────────────────────────

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.surinder-setup.enable = lib.mkForce true;

  # ── Session Variables ─────────────────────────────────────────────────
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_HWP = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # ── System Packages ───────────────────────────────────────────────────
  environment.systemPackages = [
    pkgs.git
  ];

  # ── Users ─────────────────────────────────────────────────────────────
  users.users."boing" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Boing";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "dialout"
      "plugdev"
      "input"
      "libvirtd"
      "kvm"
    ];
  };



  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.space-mono
      material-symbols
      rubik
      roboto
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        sansSerif = [
          "Inter"
          "Rubik"
        ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # ── Misc ──────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1910", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="8095", ATTR{power/control}="on"
  '';

  system.stateVersion = "26.05";
}
