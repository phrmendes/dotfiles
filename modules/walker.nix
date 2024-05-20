{
  lib,
  config,
  pkgs,
  ...
}: {
  options.walker.enable = lib.mkEnableOption "enable walker";

  config = lib.mkIf config.walker.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        terminal = lib.getExe pkgs.kitty;
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
            prefix = "'";
          }
          {
            name = "commands";
            prefix = ":";
          }
        ];
      };
    };
  };
}
