{ config, pkgs, lib, ... }:

{
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "26.05";
  
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

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_HWP = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    PROTON_ENABLE_NVAPI = "1";
    DXVK_NVAPI_ALLOW_OTHER_PROG = "1";
    VKD3D_CONFIG = "dxr11,dxr";
  };
  
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1910", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="8095", ATTR{power/control}="on"
  '';
}
