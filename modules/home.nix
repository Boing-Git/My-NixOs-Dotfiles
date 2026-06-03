{ config, pkgs, lib, inputs, ... }:

  let 
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
{
  home.username = "boing";
  home.homeDirectory = "/home/boing";
  home.stateVersion = "24.05"; 

  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.caelestia-shell.homeManagerModules.default
  ];

  # 1. Automatically install Caelestia and its complete dependency layout
  programs.caelestia = {
    enable = true;
    cli.enable = true; 
  };

  # 2. Configure Neovim and silence the legacy runtime warning flags
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };
  programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
  };

  programs.foot.enable = true;

  # 3. Directly map your cloned raw dotfiles out-of-store
  xdg.configFile = {
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/hypr";
      force = true;
    };
    "foot" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/foot";
      force = true;
    };
    "fastfetch" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/fastfetch";
      force = true;
    };
    "btop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/caelestia/btop";
      force = true;
    };
  }; # This block must close cleanly here!

  # 4. Standard Home Manager Global Pointer Option Setup
  home.pointerCursor = {
    name = "GoogleDot-Black";
    package = pkgs.google-cursor;
    size = 24; 
    gtk.enable = true;
    x11.enable = true;
  };

  # 5. Clean GTK Customization Engine Configuration Block
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "GoogleDot-Black";
      package = pkgs.google-cursor;
    };
  };

  home.activation = {
    setPapirusFolderColor = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.papirus-folders}/bin/papirus-folders -c bluegrey --theme Papirus-Dark
    '';
  };

  # Essential utility tools you want available inside your path environment
  home.packages = with pkgs; [
    fastfetch
    pavucontrol
    nemo
    vscodium
    git
    google-cursor
    dejavu_fonts # Resolves your foot font mismatch alert
    matugen
    steam
    prismlauncher
  ];

  home.sessionVariables = {
    EDITOR = "codium";
  };

  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  programs.zen-browser.enable = true;
  programs.starship.enable = true;
}
