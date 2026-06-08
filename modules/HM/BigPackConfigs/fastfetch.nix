{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "";
      };
      modules = [
        {
          type = "custom";
          format = "╭───────────────────────────────────╮";
        }
        {
          type = "kernel";
          key = "│ {#38;5;141}{#37}kernel  {#38;5;141}                     ";
          format = "{2}│";
        }
        {
          type = "shell";
          key = "│ {#38;5;141}{#37}shell   {#38;5;141}                       ";
          format = "{3}│";
        }
        {
          type = "title";
          key = "│ {#38;5;141}{#37}user    {#38;5;141}                      ";
          format = "{1}│";
        }
        {
          type = "host";
          key = "│   hname                   ";
          format = "{2} │";
        }
        {
          type = "custom";
          format = "├───────────────────────────────────┤";
        }
        {
          type = "cpu";
          key = "│ {#38;5;245}{#37}cpu     {#38;5;245}        ";
          format = "{1}│";
        }
        {
          type = "gpu";
          key = "│ {#38;5;245}{#37}󰍛 gpu     {#38;5;245}      ";
          format = "{2}│";
        }
        {
          type = "memory";
          key = "│ {#38;5;183}{#37}mem     {#38;5;183}           ";
          format = "{1}│";
        }
        {
          type = "disk";
          key = "│ {#38;5;245}{#37}󰋊 disk    {#38;5;245}          ";
          format = "{1}│";
        }
        {
          type = "custom";
          format = "├───────────────────────────────────┤";
        }
        {
          type = "os";
          key = "│ {#38;5;210}{#37}distro  {#38;5;210}      ";
          format = "{2} ({12})│";
        }
        {
          type = "wm";
          key = "│ {#38;5;210}{#37}wm      {#38;5;210}                  ";
          format = "{2}│";
        }
        {
          type = "terminal";
          key = "│ {#38;5;210}{#37}term    {#38;5;210}                     ";
          format = "{1}│";
        }
        {
          type = "packages";
          key = "│   pkgs                     ";
          format = "{1} │";
        }
        {
          type = "custom";
          format = "├───────────────────────────────────┤";
        }
        {
          type = "os";
          key = "│ {#38;5;75}{#37}nixos   {#38;5;75}           ";
          format = "{3}│";
        }
        {
          type = "custom";
          format = "├───────────────────────────────────┤";
        }
        {
          type = "localip";
          key = "│ {#38;5;245}{#37}󰤨 net     {#38;5;245}             ";
          format = "{1}│";
        }
        {
          type = "custom";
          format = "╰───────────────────────────────────╯";
        }
      ];
    };
  };
}