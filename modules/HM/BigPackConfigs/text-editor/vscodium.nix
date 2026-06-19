{ config, pkgs, lib, ... }:

{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide
        eamodio.gitlens
        vscodevim.vim
        mvllow.rose-pine
        ravenothere.rose-pine-symbols
        theqtcompany.qt-qml
        sumneko.lua
      ];

      # Merging your keybindings here
      keybindings = [
        { key = "ctrl+shift+alt+r"; command = "workbench.action.reloadWindow"; }
        { key = "ctrl+pageup"; command = "workbench.action.previousEditor"; }
        { key = "ctrl+pagedown"; command = "workbench.action.nextEditor"; }
        { key = "ctrl+shift+up"; command = "editor.action.moveLinesUpAction"; when = "editorTextFocus && !editorReadonly"; }
        { key = "ctrl+shift+down"; command = "editor.action.moveLinesDownAction"; when = "editorTextFocus && !editorReadonly"; }
        { key = "shift+alt+up"; command = "editor.action.insertCursorAbove"; when = "editorTextFocus"; }
        { key = "shift+alt+down"; command = "editor.action.insertCursorBelow"; when = "editorTextFocus"; }
        { key = "shift+h"; command = "workbench.action.previousEditor"; when = "editorTextFocus && vim.active && vim.mode == 'Normal'"; }
        { key = "shift+l"; command = "workbench.action.nextEditor"; when = "editorTextFocus && vim.active && vim.mode == 'Normal'"; }
        { key = "j"; command = "list.focusDown"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView'"; }
        { key = "k"; command = "list.focusUp"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView'"; }
        { key = "h"; command = "list.collapse"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView'"; }
        { key = "l"; command = "list.select"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView'"; }
        { key = "a"; command = "explorer.newFile"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView' && !inputFocus"; }
        { key = "shift+a"; command = "explorer.newFolder"; when = "filesToExplore && focusedView == 'workbench.explorer.fileView' && !inputFocus"; }
        { key = "a"; command = "explorer.newFile"; when = "explorerViewletFocus && !inputFocus"; }
        { key = "shift+a"; command = "explorer.newFolder"; when = "explorerViewletFocus && !inputFocus"; }
        { key = "ctrl+shift+q"; command = "workbench.action.closeActiveEditor"; when = "editorTextFocus"; }
      ];

      # Adding your files.exclude configuration seen in image_47d02d.jpg
      userSettings = {
        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/.vscode" = true;
          "**/stubs" = true;
          "**/.luarc.json" = true;
          "**/flake.lock" = true;
          "**/LICENSE" = true;
        };
      };
    };
  };

  # Activation script for the VSIX extension
  home.activation = {
    installCaelestiaExtension = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if ! ${pkgs.vscodium}/bin/codium --list-extensions | grep -iq "soramanew.caelestia-vscode-integration"; then
        ${pkgs.vscodium}/bin/codium --install-extension ${./caelestia-vscode-integration-1.2.0.vsix} --force
      fi
    '';
  };
}