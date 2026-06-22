{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.matugen.nixosModules.default # Or homeManagerModules.default depending on your setup
  ];

  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";
    palette = "default";

    # The module generates these templates into a read-only store directory
    templates = {
      ags = {
        input_path = "./templates/ags.scss";
        output_path = ".config/ags/scss/colors.scss";
      };
      kitty = {
        input_path = "./templates/kitty.conf";
        output_path = ".config/kitty/colors.conf";
      };
      gtk = {
        input_path = "./templates/gtk.css";
        output_path = ".config/gtk-4.0/gtk.css";
      };
      hypr = {
        input_path = "./templates/hypr.conf";
        output_path = ".config/hypr/colors.conf";
      };
      yazi = {
        input_path = "./templates/yazi.toml";
        output_path = ".config/yazi/theme.toml";
      };
    };
  };
}