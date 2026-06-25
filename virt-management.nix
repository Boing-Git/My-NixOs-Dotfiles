{ config, pkgs, inputs, ... }:

{
# Virtualization backend for virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # Needed for Windows 11 TPM requirements
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  # Required for virt-manager to remember its settings and window states
  programs.dconf.enable = true;

  # Allows you to pass physical USB devices from your host to the VM
  virtualisation.spiceUSBRedirection.enable = true;
}