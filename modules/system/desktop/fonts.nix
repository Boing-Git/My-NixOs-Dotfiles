{ config, pkgs, lib, ... }:

let
  # The local custom derivation for Google Sans Flex
  google-sans-flex = pkgs.stdenvNoCC.mkDerivation {
    pname = "google-sans-flex";
    version = "1.0";

    # Points directly to the file sitting next to this config
    src = ./GoogleSansFlex.ttf; 

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/GoogleSansFlex.ttf
    '';
  };
in
{
  environment.variables = {
    FREETYPE_PROPERTIES = "truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.space-mono
      material-symbols
      rubik
      roboto
      inter
      noto-fonts 
      google-sans-flex  # Your local package
      googlesans-code   # The official terminal package
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="font">
            <!-- Disable blocky embedded bitmaps inside fonts -->
            <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
          </match>
        </fontconfig>
      '';
      defaultFonts = {
        sansSerif = [
          "Google Sans Flex"
          "Inter"
          "Rubik"
        ];
        monospace = [ 
          "Google Sans Code"
          "JetBrainsMono Nerd Font"
        ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}