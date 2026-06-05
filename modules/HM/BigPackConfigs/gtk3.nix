{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    
    # Ensures a clean baseline theme for the overrides to hook into
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraCss = ''
      /* 1. Dynamic Bridge: Import Caelestia's active wallpaper palette */
      @import url("colors.css");

      /* 2. Style Mappings: Native GTK '@' variables evaluated at runtime */
      @define-color window_bg_color @base;                
      @define-color window_fg_color @text;                
      @define-color view_bg_color @base;                  
      @define-color view_fg_color @text;                  
      @define-color accent_bg_color @primary;             
      @define-color accent_fg_color @text;                
      @define-color accent_color @primary;                
      @define-color headerbar_bg_color @base;             
      @define-color headerbar_fg_color @text;             
      @define-color headerbar_backdrop_color @base;       
      @define-color headerbar_border_color @surface0;     
      @define-color headerbar_shade_color @surface0;      
      @define-color card_bg_color @base;                  
      @define-color card_fg_color @text;                  
      @define-color card_shade_color @surface0;           
      @define-color popover_bg_color @surface0;           
      @define-color popover_fg_color @text;               
      @define-color dialog_bg_color @base;                
      @define-color dialog_fg_color @text;                
      @define-color sidebar_bg_color @base;               
      @define-color sidebar_fg_color @text;               
      @define-color sidebar_backdrop_color @base;         
      @define-color sidebar_shade_color @surface0;        

      @define-color warning_bg_color @surface1;           
      @define-color warning_fg_color @yellow;             
      @define-color warning_color @surface1;              
      @define-color error_bg_color @surface1;             
      @define-color error_fg_color @error;                
      @define-color error_color @surface1;                
      @define-color success_bg_color @surface1;           
      @define-color success_fg_color @success;            
      @define-color success_color @surface1;              
      @define-color destructive_bg_color @error;          
      @define-color destructive_fg_color @text;           
      @define-color destructive_color @error;             

      /* Custom colors (GTK3 only) */
      @define-color panel_bg_color @base;                 
      @define-color panel_fg_color @text;                 
    '';
  };
}