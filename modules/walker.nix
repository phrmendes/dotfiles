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
      style = builtins.readFile ../dotfiles/walker.css;
      config = {
        enable_typeahead = true;
        fullscreen = false;
        ignore_mouse = false;
        keep_open = false;
        orientation = "vertical";
        placeholder = "Search...";
        scrollbar_policy = "automatic";
        show_initial_entries = true;
        ssh_host_file = "";
        terminal = "${lib.getExe pkgs.kitty}";
        hyprland = {
          context_aware_history = true;
        };
        activation_mode = {
          disabled = false;
          use_f_keys = false;
          use_alt = false;
        };
        search = {
          delay = 0;
          hide_icons = false;
          margin_spinner = 10;
          hide_spinner = false;
        };
        clipboard = {
          max_entries = 10;
          image_height = 300;
        };
        align = {
          ignore_exlusive = true;
          width = 400;
          horizontal = "center";
          vertical = "start";
          anchors = {
            top = false;
            left = false;
            bottom = false;
            right = false;
          };
          margins = {
            top = 20;
            bottom = 0;
            end = 0;
            start = 0;
          };
        };
        list = {
          height = 300;
          margin_top = 10;
          always_show = true;
          hide_sub = false;
        };
        icons = {
          theme = "Pop";
          hide = false;
          size = 28;
          image_height = 200;
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
