{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.surinder-setup;
in {
  options.services.surinder-setup = {
    enable = lib.mkEnableOption "Surinder Multi-User Remote Setup (XRDP & XFCE)";
  };

  config = lib.mkIf cfg.enable {
    # ── Desktop Environments ──────────────────────────────────────────────
    # Enable XFCE for the remote desktop connection
    services.xserver.desktopManager.xfce.enable = true;

    # ── Headless Remote Desktop (For Dad) ─────────────────────────────────
    services.xrdp = {
      enable = true;
      openFirewall = true;
      
      defaultWindowManager = ''
        # Safely source the system profile to populate XDG_DATA_DIRS and XDG_CONFIG_DIRS
        source /etc/profile || true

        # Export explicit XDG variables so XFCE components know they are in an XFCE session
        export XDG_CURRENT_DESKTOP=XFCE
        export XDG_SESSION_DESKTOP=xfce
        export XDG_SESSION_TYPE=x11

        # Force software rendering for OpenGL. XRDP's headless X server doesn't support the host's 
        # Nvidia GLX driver, causing xfwm4 (compositor) and xfce4-panel to crash on startup.
        export LIBGL_ALWAYS_SOFTWARE=1

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

        # Force X11 backend for GTK/QT applications. Globally exported Wayland variables from 
        # the host system (like Hyprland) will crash xfce4-panel and xfwm4 in this X11 XRDP session.
        export GDK_BACKEND=x11
        export QT_QPA_PLATFORM=xcb
        unset WAYLAND_DISPLAY

        # Fix WebKitGTK applications (like Antigravity) rendering blank or failing on XRDP headless servers
        export WEBKIT_DISABLE_COMPOSITING_MODE=1
        export WEBKIT_DISABLE_DMABUF_RENDERER=1

        # Wrap the final execution cleanly within a dedicated, isolated dbus-run-session container.
        # Explicitly launch the window manager and panel in the background to bypass xfce4-session's 
        # reliance on systemd user bus auto-starting, which fails in this isolated headless session.
        exec ${pkgs.dbus}/bin/dbus-run-session sh -c "
          ${pkgs.xfwm4}/bin/xfwm4 --compositor=off &
          ${pkgs.xfce4-panel}/bin/xfce4-panel &
          exec ${pkgs.xfce4-session}/bin/startxfce4
        "
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
  };
}
