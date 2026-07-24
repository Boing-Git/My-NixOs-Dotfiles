{ config, pkgs, ... }: {

  home.file = {
    ".config/btop".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/btop";
    ".config/cava".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/cava";
    ".config/fastfetch".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/fastfetch";
    ".config/fish".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/fish";
    ".config/foot".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/foot";
    ".config/fuzzel".source     = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/fuzzel";
    ".config/htop".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/htop";
    ".config/matugen".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/matugen";
    ".config/nvim".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/nvim";
    ".config/nvtop".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/nvtop";
    ".config/nwg-look".source   = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/nwg-look";
    ".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/quickshell";
    ".config/starship".source   = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/starship";
    ".config/wezterm".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/wezterm";
    ".config/color-schemes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/color-schemes"; 
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/hypr"; 
    ".config/spicetify".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/spicetify";
  };

}
