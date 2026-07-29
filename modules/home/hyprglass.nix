{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprglass";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "v0.6.4";
    hash = ""; # This will fail first time and give us the correct hash
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ ];

  meta = {
    homepage = "https://github.com/hyprnux/hyprglass";
    description = "Liquid Glass plugin for Hyprland";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
