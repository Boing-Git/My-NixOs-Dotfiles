{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    rustc
    cargo
    gcc
    rustup
    cmake
    ninja
    pkg-config
    qt6.qtbase
    qt6.qtdeclarative
    qt6.wrapQtAppsHook
    (python3.withPackages (
      ps: with ps; [
        tkinter
        pygobject3
        pywebview
        flask
        emoji
        typer
        rich
        python-magic
      ]
    ))
  ];
}
