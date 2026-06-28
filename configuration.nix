{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
    ./virt-management.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ── Display Manager ───────────────────────────────────────────────────
  services.displayManager = {
    defaultSession = "hyprland";

    # Forces SDDM to always launch Hyprland for boing without showing
    # the session picker.
    autoLogin.enable = true;
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
  # Enable XFCE for the remote desktop connection
  services.xserver.desktopManager.xfce.enable = true;

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

  # ── Headless Remote Desktop (For Dad) ─────────────────────────────────
# ── Headless Remote Desktop (For Dad) ─────────────────────────────────
  services.xrdp = {
    enable = true;
    openFirewall = true;
    
    defaultWindowManager = ''
      # Clear any local host session variables that break headless displays
      unset DBUS_SESSION_BUS_ADDRESS
      unset XDG_RUNTIME_DIR
      unset SESSION_MANAGER
      
      # Clean out old XFCE configuration locks if any exist
      rm -rf ~/.cache/sessions/*

      # Force standard system profile path inclusion for the current shell context
      export PATH=$PATH:/run/current-system/sw/bin

      # Inject native HiDPI font scaling metrics using the top-level xrdb package
      echo "Xft.dpi: 192" | ${pkgs.xrdb}/bin/xrdb -merge

      # Set explicit environment scaling properties for layout structures
      export GDK_SCALE=2
      export GDK_DPI_SCALE=0.5
      export QT_SCALE_FACTOR=2

      # Pass control over to the standard XFCE initialization script which handles WM and panel setup
      exec ${pkgs.xfce4-session}/bin/startxfce4
    '';
  };

# Clean, modern OpenSSH service configuration
services.openssh = {
  enable = true;
  settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
  };
};

# Explicitly open the ports using the standard firewall list 
networking.firewall.allowedTCPPorts = [ 22 3389 ];

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

  # Separate user account for your dad
  users.users."surinder" = {
    isNormalUser = true;
    description = "surinder singh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
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
