{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    git
    nixfmt-rfc-style
    nixd
  ];
}
