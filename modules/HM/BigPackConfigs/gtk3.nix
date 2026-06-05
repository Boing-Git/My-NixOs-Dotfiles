{ config, pkgs, ... }:

{
  # ── GTK Theme Base ───────────────────────────────────────────────────────────
  # adw-gtk3 MUST be the active theme for named colors to resolve correctly.
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
    # Maps the dynamic Caelestia/Matugen Breeze tokens to adw-gtk3's interface contract.
    gtk3.extraCss = ''
      /* ── Dynamic Bridge ────────────────────────────────── */
      @import url("colors.css");

      /* ── Core Window ───────────────────────────────────── */
      @define-color window_bg_color          @theme_bg_color_breeze;
      @define-color window_fg_color          @theme_fg_color_breeze;
      @define-color view_bg_color            @theme_base_color_breeze;
      @define-color view_fg_color            @theme_text_color_breeze;

      /* ── Accent ────────────────────────────────────────── */
      @define-color accent_bg_color          @theme_selected_bg_color_breeze;
      @define-color accent_fg_color          @theme_selected_fg_color_breeze;
      @define-color accent_color             @theme_view_active_decoration_color_breeze;

      /* ── Headerbar ─────────────────────────────────────── */
      @define-color headerbar_bg_color       @theme_header_background_breeze;
      @define-color headerbar_fg_color       @theme_header_foreground_breeze;
      @define-color headerbar_backdrop_color @theme_header_background_backdrop_breeze;
      @define-color headerbar_border_color   @borders_breeze;
      @define-color headerbar_shade_color    @borders_breeze;

      /* ── Cards & Lists ─────────────────────────────────── */
      @define-color card_bg_color            @theme_base_color_breeze;
      @define-color card_fg_color            @theme_text_color_breeze;
      @define-color card_shade_color         @borders_breeze;

      /* ── Popovers & Menus ──────────────────────────────── */
      @define-color popover_bg_color         @theme_unfocused_view_bg_color_breeze;
      @define-color popover_fg_color         @theme_text_color_breeze;

      /* ── Dialogs ───────────────────────────────────────── */
      @define-color dialog_bg_color          @theme_bg_color_breeze;
      @define-color dialog_fg_color          @theme_text_color_breeze;

      /* ── Sidebar ───────────────────────────────────────── */
      @define-color sidebar_bg_color         @theme_bg_color_breeze;
      @define-color sidebar_fg_color         @theme_fg_color_breeze;
      @define-color sidebar_backdrop_color   @theme_unfocused_bg_color_breeze;
      @define-color sidebar_shade_color      @borders_breeze;

      /* ── Semantic States ───────────────────────────────── */
      @define-color warning_bg_color         @theme_bg_color_breeze;
      @define-color warning_fg_color         @warning_color_breeze;
      @define-color warning_color            @warning_color_breeze;

      @define-color error_bg_color           @theme_bg_color_breeze;
      @define-color error_fg_color           @error_color_breeze;
      @define-color error_color              @error_color_breeze;

      @define-color success_bg_color         @theme_bg_color_breeze;
      @define-color success_fg_color         @success_color_breeze;
      @define-color success_color            @success_color_breeze;

      @define-color destructive_bg_color     @error_color_breeze;
      @define-color destructive_fg_color     @theme_selected_fg_color_breeze;
      @define-color destructive_color        @error_color_breeze;
    '';

    # ── GTK4 Color Overrides ──────────────────────────────────────────────────
    # Feeds the same dynamic tokens to libadwaita/GTK4 structures natively.
    gtk4.extraCss = ''
      /* ── Dynamic Bridge ────────────────────────────────── */
      @import url("colors.css");

      /* ── Core Window ───────────────────────────────────── */
      @define-color window_bg_color          @theme_bg_color_breeze;
      @define-color window_fg_color          @theme_fg_color_breeze;
      @define-color view_bg_color            @theme_base_color_breeze;
      @define-color view_fg_color            @theme_text_color_breeze;

      /* ── Accent ────────────────────────────────────────── */
      @define-color accent_bg_color          @theme_selected_bg_color_breeze;
      @define-color accent_fg_color          @theme_selected_fg_color_breeze;
      @define-color accent_color             @theme_view_active_decoration_color_breeze;

      /* ── Headerbar ─────────────────────────────────────── */
      @define-color headerbar_bg_color       @theme_header_background_breeze;
      @define-color headerbar_fg_color       @theme_header_foreground_breeze;

      /* ── Cards & Lists ─────────────────────────────────── */
      @define-color card_bg_color            @theme_base_color_breeze;
      @define-color card_fg_color            @theme_text_color_breeze;

      /* ── Popovers & Menus ──────────────────────────────── */
      @define-color popover_bg_color         @theme_unfocused_view_bg_color_breeze;
      @define-color popover_fg_color         @theme_text_color_breeze;

      /* ── Dialogs ───────────────────────────────────────── */
      @define-color dialog_bg_color          @theme_bg_color_breeze;
      @define-color dialog_fg_color          @theme_text_color_breeze;

      /* ── Sidebar ───────────────────────────────────────── */
      @define-color sidebar_bg_color         @theme_bg_color_breeze;
      @define-color sidebar_fg_color         @theme_fg_color_breeze;
    '';
  };

  # ── Required packages ────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
    gsettings-desktop-schemas
  ];

  # ── Apply theme via gsettings at session start ────────────────────────────────
  wayland.windowManager.hyprland.settings.exec-once = [
    "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"
    "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
  ];
}