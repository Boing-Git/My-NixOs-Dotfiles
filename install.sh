#!/bin/bash

git clone https://github.com/Boing-Git/My-NixOs-Dotfiles ~/Nixos
cd ~/Nixos

cp -r ~/Nixos/quickshell ~/.config/quickshell

cp /etc/nixos/hardware-configuration.nix ./

sudo nixos-rebuild switch --flake .#nixos
