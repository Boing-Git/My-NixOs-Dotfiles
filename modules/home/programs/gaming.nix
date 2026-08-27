# Save or import this module directly in your /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # 1. Allow Unfree Software (Required for Steam & NVIDIA Drivers)
  nixpkgs.config.allowUnfree = true;

  # 2. NVIDIA Proprietary Driver Configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necessary for 32-bit game binaries
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Keep false to use proprietary drivers for peak 3080 Ti performance
    nvidiaSettings = true;
    powerManagement.enable = false;
  };

  # 3. CPU Performance Governor (Forces Ryzen 9 5950X to sustain max clocks)
  powerManagement.cpuFreqGovernor = "performance";

  # 4. Kernel Sysctl Tweaks (Fixes memory allocation crashes in EAC/The Finals)
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # 5. Enable Steam and Feral GameMode
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Helps bypass Wayland/XWayland frame caps
  };
}