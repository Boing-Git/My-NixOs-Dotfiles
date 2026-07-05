{ config, pkgs, ... }: {

  # 1. Tell Home Manager to configure the Qt subsystem framework
  qt = {
    enable = true;
    platformTheme.name = "qt5ct"; # Instructs both Qt5 and Qt6 to obey qt5ct/qt6ct engines
  };

  # 2. Inject global variables so applications know to look for qtct
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Optional: Keeps scaling neat across monitors
  };

  # 3. Declaratively manage the main application configuration files
  xdg.configFile = {
    # Configure Qt5 Configuration Tool settings
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=${config.xdg.configHome}/color-schemes/current/qtColors.conf
      custom_palette=true
      style=Fusion
      icon_theme=Adwaita

      [Fonts]
      General="Sans Serif,10,-1,5,50,0,0,0,0,0"
      Fixed="Monospace,10,-1,5,50,0,0,0,0,0"
    '';

    # Configure Qt6 Configuration Tool settings
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=${config.xdg.configHome}/color-schemes/current/qtColors.conf
      custom_palette=true
      style=Fusion
      icon_theme=Adwaita

      [Fonts]
      General="Sans Serif,10,-1,5,50,0,0,0,0,0"
      Fixed="Monospace,10,-1,5,50,0,0,0,0,0"
    '';
  };
}
