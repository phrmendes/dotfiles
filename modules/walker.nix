{
  lib,
  config,
  pkgs,
  ...
}: {
  options.walker.enable = lib.mkEnableOption "enable walker";

  config = lib.mkIf config.walker.enable {
    programs.walker = let
      kitty = lib.getExe pkgs.kitty;
    in {
      enable = true;
      runAsService = false;
      style = builtins.readFile ../dotfiles/walker/style.css;
      config = {
        activation_mode.disable = false;
        enable_typeahead = true;
        fullscreen = false;
        hyprland.context_aware_history = true;
        ignore_mouse = false;
        notify_on_fail = true;
        placeholder = "Search...";
        scrollbar_policy = "automatic";
        search.hide_icons = false;
        show_initial_entries = true;
        terminal = kitty;
        align = {
          horizontal = "center";
          width = 500;
        };
        icons = {
          hide = false;
          size = 28;
          image_height = 200;
        };
        list = {
          margin_top = 10;
          height = 500;
          always_show = true;
        };
        clipboard = {
          image_height = 300;
          max_entries = 10;
        };
        modules = [
          {
            name = "applications";
            prefix = "";
          }
          {
            name = "hyprland";
            prefix = "=";
          }
          {
            name = "switcher";
            prefix = "/";
          }
          {
            name = "finder";
            prefix = "~";
            switcher_exclusive = true;
          }
          {
            name = "websearch";
            prefix = "?";
            switcher_exclusive = true;
          }
        ];
      };
    };
  };
}
