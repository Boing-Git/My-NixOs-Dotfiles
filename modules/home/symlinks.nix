{ config, pkgs, ... }: {

  home.file = {
    ".config/btop".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/btop";
    ".config/cava".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/cava";
    ".config/fastfetch".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fastfetch";
    ".config/fish".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fish";
    ".config/foot".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/foot";
    ".config/fuzzel".source     = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fuzzel";
    ".config/htop".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/htop";
    ".config/matugen".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/matugen";
    ".config/nvim".source       = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/nvtop".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvtop";
    ".config/nwg-look".source   = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nwg-look";
    ".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/quickshell";
    ".config/starship".source   = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship";
    ".config/wezterm".source    = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
    ".config/zed".source        = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed";
    ".config/color-schemes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/color-schemes"; 
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr"; 
  };

}
