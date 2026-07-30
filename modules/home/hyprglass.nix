{
  lib,
  fetchFromGitHub,
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
    hash = "sha256-coVoTJyRhn6eKZ8oJXus93p/G1gblgqcQNhNXBhx+G4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ];

  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
  '';

  meta = {
    homepage = "https://github.com/hyprnux/hyprglass";
    description = "Liquid Glass plugin for Hyprland";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
