{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Boingly";
        email = "BoingDoing@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
