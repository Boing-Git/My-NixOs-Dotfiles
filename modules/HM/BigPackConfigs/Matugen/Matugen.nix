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

  # Now, link the generated files from the matugen store path to your actual config directories
  # as shown in image_aa5b45.png
  home.configFile = {
    "ags/scss/colors.scss".source = "${config.programs.matugen.theme.files}/.config/ags/scss/colors.scss";
    "kitty/colors.conf".source = "${config.programs.matugen.theme.files}/.config/kitty/colors.conf";
    "gtk-4.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css";
    "hypr/colors.conf".source = "${config.programs.matugen.theme.files}/.config/hypr/colors.conf";
    "yazi/theme.toml".source = "${config.programs.matugen.theme.files}/.config/yazi/theme.toml";
  };
}