{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "pcie_aspm=off"
  ];
  boot.extraModprobeConfig = ''
    options rtw88_core disable_aspm=y
    options rtl8821ae aspm=0
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "ntsync" ];
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
}
