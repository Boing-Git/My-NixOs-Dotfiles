{ config, pkgs, ... }:

let
  # ── Color Palette ────────────────────────────────────────────────────────────
  # Jivan Singh — Material 3 / Custom dark scheme
  # Single source of truth: change here, propagates everywhere.
  colors = {
    base     = "
    text     = "#7cc8b5";   # soft lavender white — primary text
    primary  = "#6305d5";   # vivid violet — accent / interactive
    surface0 = "#313244";   # dark grey — borders, cards
    surface1 = "#45475a";   # mid grey — raised surfaces, warning bg
    yellow   = "#f9e2af";   # peach yellow — warning foreground
    error    = "#f38ba8";   # soft red — error foreground
    success  = "#a6e3a1";   # mint green — success foreground
  };
in
{
  # ── GTK Theme Base ───────────────────────────────────────────────────────────
  # adw-gtk3 MUST be the active theme for named colors to resolve correctly.
  # Without this, @define-color tokens are injected but never consumed.
  gtk = {
    enable = true;

    theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # ── GTK3 Named Color Overrides ─────────────────────────────────────────────
    # These map to adw-gtk3's documented color contract.
    # Written as CSS custom properties — adw-gtk3 reads them on startup.
    gtk3.extraCss = ''
      /* ── Core Window ───────────────────────────────────── */
      @define-color window_bg_color        ${colors.base};
      @define-color window_fg_color        ${colors.text};
      @define-color view_bg_color          ${colors.base};
      @define-color view_fg_color          ${colors.text};

      /* ── Accent ────────────────────────────────────────── */
      @define-color accent_bg_color        ${colors.primary};
      @define-color accent_fg_color        ${colors.text};
      @define-color accent_color           ${colors.primary};

      /* ── Headerbar ─────────────────────────────────────── */
      @define-color headerbar_bg_color     ${colors.base};
      @define-color headerbar_fg_color     ${colors.text};
      @define-color headerbar_backdrop_color ${colors.base};
      @define-color headerbar_border_color ${colors.surface0};
      @define-color headerbar_shade_color  ${colors.surface0};

      /* ── Cards & Lists ─────────────────────────────────── */
      @define-color card_bg_color          ${colors.base};
      @define-color card_fg_color          ${colors.text};
      @define-color card_shade_color       ${colors.surface0};

      /* ── Popovers & Menus ──────────────────────────────── */
      @define-color popover_bg_color       ${colors.surface0};
      @define-color popover_fg_color       ${colors.text};

      /* ── Dialogs ───────────────────────────────────────── */
      @define-color dialog_bg_color        ${colors.base};
      @define-color dialog_fg_color        ${colors.text};

      /* ── Sidebar ───────────────────────────────────────── */
      @define-color sidebar_bg_color       ${colors.base};
      @define-color sidebar_fg_color       ${colors.text};
      @define-color sidebar_backdrop_color ${colors.base};
      @define-color sidebar_shade_color    ${colors.surface0};

      /* ── Semantic States ───────────────────────────────── */
      @define-color warning_bg_color       ${colors.surface1};
      @define-color warning_fg_color       ${colors.yellow};
      @define-color warning_color          ${colors.yellow};

      @define-color error_bg_color         ${colors.surface1};
      @define-color error_fg_color         ${colors.error};
      @define-color error_color            ${colors.error};

      @define-color success_bg_color       ${colors.surface1};
      @define-color success_fg_color       ${colors.success};
      @define-color success_color          ${colors.success};

      @define-color destructive_bg_color   ${colors.error};
      @define-color destructive_fg_color   ${colors.text};
      @define-color destructive_color      ${colors.error};

      /* ── GTK3-only extras (XFCE4 panel etc.) ───────────── */
      @define-color panel_bg_color         ${colors.base};
      @define-color panel_fg_color         ${colors.text};
    '';

    # ── GTK4 (libadwaita apps — same palette) ─────────────────────────────────
    # home-manager writes this to ~/.config/gtk-4.0/gtk.css
    gtk4.extraCss = ''
      @define-color window_bg_color        ${colors.base};
      @define-color window_fg_color        ${colors.text};
      @define-color view_bg_color          ${colors.base};
      @define-color view_fg_color          ${colors.text};
      @define-color accent_bg_color        ${colors.primary};
      @define-color accent_fg_color        ${colors.text};
      @define-color accent_color           ${colors.primary};
      @define-color headerbar_bg_color     ${colors.base};
      @define-color headerbar_fg_color     ${colors.text};
      @define-color card_bg_color          ${colors.base};
      @define-color card_fg_color          ${colors.text};
      @define-color popover_bg_color       ${colors.surface0};
      @define-color popover_fg_color       ${colors.text};
      @define-color dialog_bg_color        ${colors.base};
      @define-color dialog_fg_color        ${colors.text};
      @define-color sidebar_bg_color       ${colors.base};
      @define-color sidebar_fg_color       ${colors.text};
    '';
  };

  # ── Required packages ────────────────────────────────────────────────────────
  # adw-gtk3 and papirus must be explicitly available in the user environment.
  # They are referenced above by name — Home Manager does NOT auto-install them.
  home.packages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
    gsettings-desktop-schemas   # needed for gsettings to apply theme at login
  ];

  # ── Apply theme via gsettings at session start ────────────────────────────────
  # Without this, the GTK theme name is set in files but GDK won't pick it up
  # in all apps. This fires once when your Hyprland session initialises.
  wayland.windowManager.hyprland.settings.exec-once = [
    "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"
    "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
  ];
}
