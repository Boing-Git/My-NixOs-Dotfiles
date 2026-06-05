{ config, pkgs, ... }:

let
  # Define your color palette variables here. 
  # (Example hex values provided below match a standard dark palette like Catppuccin Mocha)
  colors = {
    base     = "#1e1e2e"; 
    text     = "#cdd6f4";
    primary  = "#cba6f7";
    surface0 = "#313244";
    surface1 = "#45475a";
    yellow   = "#f9e2af";
    error    = "#f38ba8";
    success  = "#a6e3a1";
  };
in
{
  gtk = {
    enable = true;
    
    gtk3.extraCss = ''
      @define-color window_bg_color ${colors.base};                /* The main background color used on GtkWindow */
      @define-color window_fg_color ${colors.text};                /* The main foreground text color */
      @define-color view_bg_color ${colors.base};                  /* A secondary background color used in icon views, text fields, etc */
      @define-color view_fg_color ${colors.text};                  /* Secondary foreground text color */
      @define-color accent_bg_color ${colors.primary};             /* Color to indicate that a widget is important, interactive, or currently active */
      @define-color accent_fg_color ${colors.text};                /* Color for text over widgets using accent_bg_color */
      @define-color accent_color ${colors.primary};                /* Mostly used for text labels. Can be the same as accent_bg_color */
      @define-color headerbar_bg_color ${colors.base};             /* The headerbar background */
      @define-color headerbar_fg_color ${colors.text};             /* The headerbar foreground text color */
      @define-color headerbar_backdrop_color ${colors.base};       /* The headerbar backdrop state background */
      @define-color headerbar_border_color ${colors.surface0};     /* Currently not used in adw-gtk3 */
      @define-color headerbar_shade_color ${colors.surface0};      /* The bottom border of the headerbar */
      @define-color card_bg_color ${colors.base};                  /* The background color of lists */
      @define-color card_fg_color ${colors.text};                  /* The text color on libhandy lists */
      @define-color card_shade_color ${colors.surface0};           /* List borders */
      @define-color popover_bg_color ${colors.surface0};           /* The background color of popovers and menus */
      @define-color popover_fg_color ${colors.text};               /* The text color on popovers */
      @define-color dialog_bg_color ${colors.base};                /* The background color of message dialogs */
      @define-color dialog_fg_color ${colors.text};                /* The foreground color of message dialogs */
      @define-color sidebar_bg_color ${colors.base};               /* Sidebar background color */
      @define-color sidebar_fg_color ${colors.text};               /* Sidebar foreground color */
      @define-color sidebar_backdrop_color ${colors.base};         /* Sidebar backdrop background color */
      @define-color sidebar_shade_color ${colors.surface0};        /* Sidebar shade color */

      @define-color warning_bg_color ${colors.surface1};           /* Background for widgets and elements that show a warning */
      @define-color warning_fg_color ${colors.yellow};             /* Foreground for widgets and elements that show a warning */
      @define-color warning_color ${colors.surface1};              /* Warning text label */
      @define-color error_bg_color ${colors.surface1};             /* Background for widgets and elements that show an error */
      @define-color error_fg_color ${colors.error};                /* Foreground for widgets and elements that show an error */
      @define-color error_color ${colors.surface1};                /* Error text label */
      @define-color success_bg_color ${colors.surface1};           /* Background for widgets and elements that show a successful action */
      @define-color success_fg_color ${colors.success};            /* Foreground for widgets and elements that show a successful action */
      @define-color success_color ${colors.surface1};              /* Success text label */
      @define-color destructive_bg_color ${colors.error};          /* The destructive color indicates a dangerous action, such as deleting a file */
      @define-color destructive_fg_color ${colors.text};           /* Destructive foreground color */
      @define-color destructive_color ${colors.error};             /* Destructive text label */

      /* Custom colors (GTK3 only) */
      @define-color panel_bg_color ${colors.base};                 /* Background for XFCE4 panel */
      @define-color panel_fg_color ${colors.text};                 /* Foreground for XFCE4 panel */
    '';
  };
}