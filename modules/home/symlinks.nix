{ config, pkgs, ... }: {

  home.file = {
    ".config/btop".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/btop;
    ".config/cava".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/cava;
    ".config/fastfetch".source  = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/fastfetch;
    ".config/fish".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/fish;
    ".config/foot".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/foot;
    ".config/fuzzel".source     = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/fuzzel;
    ".config/htop".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/htop;
    ".config/matugen".source    = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/matugen;
    ".config/nvim".source       = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/nvim;
    ".config/nvtop".source      = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/nvtop;
    ".config/nwg-look".source   = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/nwg-look;
    ".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/quickshell;
    ".config/starship".source   = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/starship;
    ".config/wezterm".source    = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/wezterm;
    ".config/zed".source        = config.lib.file.mkOutOfStoreSymlink /home/jivan/dotfiles/zed;
  };

}
