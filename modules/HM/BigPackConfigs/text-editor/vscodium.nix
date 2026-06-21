{ config, pkgs, lib, ... }:

{
  # 1. Add qtdeclarative to your user packages to provide the 'qmlls' binary
  home.packages = with pkgs; [
    qt6.qtdeclarative
  ];

  # 2. Declaratively create the empty marker file the LSP needs to scan the directory
  home.file.".config/quickshell/Pill/.qmlls.ini".text = "";

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
        theqtcompany.qt-qml # This handles QML language features
        sumneko.lua
        naumovs.color-highlight
        # Add the embedded browser
        antfu.browse-lite
      ];

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

      userSettings = {
        "workbench.colorTheme" = "Caelestia";
        "workbench.statusBar.visible" = false;
        "window.menuBarVisibility" = "hidden";
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        "workbench.browser.showInTitleBar" = false;
        "workbench.editor.enablePreview" = false;
        "editor.minimap.enabled" = false;
        "window.customTitleBarVisibility" = "windowed";
        "window.titleBarStyle" = "native";
        "keyboard.dispatch" = "keyCode";
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

        # 3. Add QML Language Server specific settings
        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
        "qt-qml.qmlls.extraQmllsArguments" = [
          "--import-path"
          "/run/current-system/sw/lib/qt-6/qml"
        ];

        # Use Rubik as the primary font
        "editor.fontFamily" = "'Rubik', 'monospace', monospace";
        
        "editor.fontSize" = 16;
        
        # Disabled since standard Rubik does not feature programming ligatures
        "editor.fontLigatures" = false;

        # Set line numbers to relative
        "editor.lineNumbers" = "relative";

        # 2. Force VSCodium to associate .qml files with the QML language
      "files.associations" = {
        "*.qml" = "qml";
      };
      };
    };
  };

  home.activation = {
    installCaelestiaExtension = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if ! ${pkgs.vscodium}/bin/codium --list-extensions | grep -iq "soramanew.caelestia-vscode-integration"; then
        ${pkgs.vscodium}/bin/codium --install-extension ${./caelestia-vscode-integration-1.2.0.vsix} --force
      fi
    '';
  };
}