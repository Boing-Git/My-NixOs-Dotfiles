{ config, pkgs, inputs, ... }:

let
  # A helper that cleanly formats standard Nix attribute sets into valid TOML syntax
  tomlFormat = pkgs.formats.toml { };
in
{
  # 1. Install the matugen binary package directly from the flake inputs
  home.packages = [
    inputs.matugen.packages.${pkgs.system}.default
  ];

  # 2. Force Home Manager to construct and symlink your config.toml
  xdg.configFile."matugen/config.toml".source = tomlFormat.generate "matugen-config" {
    config = {
      variant = "dark";
      json_format = "hex";
    };

    # These strings will be written straight into your config.toml file
    templates = {
      foot = {
        input_path = "${config.xdg.configHome}/matugen/Templates/footTheme.ini";
        output_path = "${config.xdg.configHome}/foot/theme.ini";
      };
      quickshell = {
        input_path = "${config.xdg.configHome}/matugen/Templates/quickshellColors.js";
        output_path = "${config.xdg.configHome}/quickshell/Colors/colors.js";
      };
    };
  };
}