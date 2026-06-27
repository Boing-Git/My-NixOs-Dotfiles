#!/bin/bash

git clone https://github.com/Boing-Git/NixOs-Dotfiles ~/Nixos
cd ~/Nixos

mkdir -p ~/.config/quickshell
git clone https://github.com/Boing-Git/Quickshell-Dotfiles ~/.config/quickshell

mkdir -p ~/.config/hypr
git clone https://github.com/Boing-Git/Hyprland-Dotfiles ~/.config/hypr

cp /etc/nixos/hardware-configuration.nix ./

sudo nixos-rebuild switch --flake .#nixos
