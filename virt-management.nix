{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.virt-management;
in {
  options.progs.virt-maramnagement = {
    enable = lib.mkEnableOption "virt-management module";
  };

  config = lib.mkIf cfg.enable {
    # Virtualization backend for virt-manager
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true; # Needed for Windows 11 TPM requirements
      };
    };

    # Required for virt-manager to remember its settings and window states
    programs.dconf.enable = true;

    # Allows you to pass physical USB devices from your host to the VM
    virtualisation.spiceUSBRedirection.enable = true;
    
    # We ensure the virt-manager application itself is also available when enabled
    environment.systemPackages = [ pkgs.virt-manager ];
  };
}
