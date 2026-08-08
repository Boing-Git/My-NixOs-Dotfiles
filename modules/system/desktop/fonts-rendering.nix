{ config, lib, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  fonts.fontconfig.confPackages = [
    (pkgs.writeTextDir "etc/fonts/conf.d/52-macos-style-rendering.conf" ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="font">
          <edit name="antialias" mode="assign"><bool>true</bool></edit>
          <edit name="hinting" mode="assign"><bool>true</bool></edit>
          <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
          <edit name="autohint" mode="assign"><bool>false</bool></edit>
          <edit name="rgba" mode="assign"><const>none</const></edit>
          <edit name="lcdfilter" mode="assign"><const>lcdnone</const></edit>
        </match>
      </fontconfig>
    '')
  ];
}
