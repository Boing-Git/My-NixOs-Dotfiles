{ config, pkgs, ... }:

let
  # ─────────────────────────────────────────────────────────────────────────
  # Caelestia SDDM Locklike theme derivation
  #
  # WHY this works:
  #   The repo (ItsABigIgloo/caelestia-sddm) stores the Locklike theme files
  #   at the REPOSITORY ROOT, not inside a subdirectory called "Locklike".
  #   Previous attempts either:
  #     (a) tried `cp -aR themes/Locklike` → stat error, path doesn't exist
  #     (b) tried `cp -aR .` into a named dir → put the whole repo root there,
  #         breaking relative QML imports and metadata resolution
  #
  #   The correct install is:
  #     mkdir -p $out/share/sddm/themes/Locklike
  #     cp -aR . $out/share/sddm/themes/Locklike/
  #
  #   This is exactly what the upstream AUR PKGBUILD does.
  #   We also generate a clean metadata.desktop because the repo does NOT
  #   ship one (it's not at the root; if it were, we'd use it).
  # ─────────────────────────────────────────────────────────────────────────
  caelestia-sddm-locklike = pkgs.stdenv.mkDerivation {
    pname = "caelestia-sddm-locklike";
    version = "unstable-2024";

    src = pkgs.fetchFromGitHub {
      owner  = "ItsABigIgloo";
      repo   = "caelestia-sddm";
      rev    = "main";
      # If this hash is wrong, delete this line, run the rebuild, and paste
      # the "got:" hash from the error output here.
      sha256 = "sha256-/fUG5xt6Drz8o1cwDbYCMkac5X6hDmieQ02GFSzjNuU=";
    };

    dontBuild   = true;
    dontFixup   = true;  # don't let Nix's fixup phase touch QML files

    installPhase = ''
      runHook preInstall

      # The Locklike theme files live at the repository root.
      # We create the named theme directory and copy everything into it.
      mkdir -p $out/share/sddm/themes/Locklike
      cp -aR . $out/share/sddm/themes/Locklike/

      # Write a clean metadata.desktop.
      # QtVersion=6 is required for SDDM's Wayland/Qt6 build to accept this.
      cat > $out/share/sddm/themes/Locklike/metadata.desktop << 'EOF'
[Desktop Entry]
Name=Locklike
Comment=Caelestia SDDM Locklike Theme
Type=sddm-theme
ConfigFile=theme.conf
QtVersion=6
EOF

      runHook postInstall
    '';

    meta = {
      description = "Caelestia SDDM Locklike login theme";
      homepage    = "https://github.com/ItsABigIgloo/caelestia-sddm";
      license     = pkgs.lib.licenses.gpl3;
    };
  };

in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/programs.nix
  ];

  # ── Bootloader ──────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams                    = [ "usbcore.autosuspend=-1" ];
  boot.kernelPackages                  = pkgs.linuxPackages_latest;

  # ── Display Manager ─────────────────────────────────────────────────────
  services.displayManager = {
    defaultSession = "hyprland";

    sddm = {
      enable = true;

      # Explicitly use the Qt6 build of SDDM from kdePackages.
      # Without this, wayland.enable = true can still start a Qt5 binary that
      # cannot load Qt6 QML themes, or it picks up mismatched QML plugins.
      package = pkgs.kdePackages.sddm;

      wayland.enable = true;
      theme          = "Locklike";

      # extraPackages injects QML plugin paths into the SDDM wrapper's
      # QML2_IMPORT_PATH. Every Qt6 module the theme's QML imports need
      # must be listed here. Missing one = blank/broken login screen.
      extraPackages = [
        caelestia-sddm-locklike          # the theme itself
        pkgs.kdePackages.qt5compat       # QtGraphicalEffects (still used by many Qt6 themes)
        pkgs.kdePackages.qtsvg           # SVG icon rendering
        pkgs.kdePackages.qtdeclarative   # QML engine / QtQuick
        pkgs.kdePackages.qtwayland       # Wayland platform plugin
        pkgs.kdePackages.qqc2-desktop-style  # QtQuick Controls 2 styling
        pkgs.kdePackages.breeze-icons    # fallback icon set so icons don't go missing
        pkgs.kdePackages.qtmultimedia    # blur / video / multimedia QML types
      ];
    };
  };

  # ── Networking ──────────────────────────────────────────────────────────
  networking.hostName              = "nixos";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable        = true;

  # ── Locale & Time ───────────────────────────────────────────────────────
  time.timeZone      = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Graphics / Nvidia ───────────────────────────────────────────────────
  services.xserver.enable = true;

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable     = true;
    powerManagement.enable = false;
    open                   = false;
    nvidiaSettings         = true;
    package                = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ── System Environment ──────────────────────────────────────────────────
  environment.systemPackages = [
    pkgs.git
    caelestia-sddm-locklike  # must appear here AND in sddm.extraPackages
    pkgs.kdePackages.kate
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS    = "1";
    NIXOS_OZONE_HWP            = "1";
    GBM_BACKEND                = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME  = "nvidia";
    LIBVA_DRIVER_NAME          = "nvidia";
  };

  # ── Users ───────────────────────────────────────────────────────────────
  users.users."boing" = {
    shell        = pkgs.fish;
    isNormalUser = true;
    description  = "Boing";
    extraGroups  = [ "networkmanager" "wheel" "video" "dialout" "plugdev" "input" ];
  };

  # ── Fonts ────────────────────────────────────────────────────────────────
  # Locklike mandatory fonts (per AUR package deps):
  #   - material-symbols  → icon glyphs (rounded variant used by Locklike)
  #   - rubik             → primary UI font
  #   - roboto            → secondary / fallback UI font
  #
  # nerd-fonts.caskaydia-cove is the CORRECT attribute name.
  # "cascadia-code" does not exist in pkgs.nerd-fonts and never did.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove  # patched Cascadia Code — correct Nixpkgs attr name
    material-symbols           # provides rounded icons Locklike QML references
    rubik                      # primary UI font for Locklike
    roboto                     # fallback UI font
  ];

  # ── Misc ────────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;
  services.printing.enable   = true;

  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  system.stateVersion = "26.05";
}
