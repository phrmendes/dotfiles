{
  lib,
  config,
  pkgs,
  ...
}: {
  options.walker.enable = lib.mkEnableOption "enable walker";

  config = lib.mkIf config.walker.enable {
    programs.walker = let
      style = ''
        * {
          color: #${config.lib.stylix.colors.base07};
        }

        #window {
        }

        #box {
          background: #${config.lib.stylix.colors.base00};
          padding: 10px;
          border-radius: 2px;
        }

        #searchwrapper {
        }

        #search,
        #typeahead {
          border-radius: 0;
          outline: none;
          outline-width: 0px;
          box-shadow: none;
          border-bottom: none;
          border: none;
          background: #${config.lib.stylix.colors.base00};
          padding-left: 10px;
          padding-right: 10px;
          padding-top: 0px;
          padding-bottom: 0px;
          border-radius: 2px;
        }

        #spinner {
          opacity: 0;
        }

        #spinner.visible {
          opacity: 1;
        }

        #typeahead {
          background: none;
          opacity: 0.5;
        }

        #search placeholder {
          opacity: 0.5;
        }

        #list {
        }

        row:selected {
          background: #${config.lib.stylix.colors.base01};
        }

        .item {
          padding: 5px;
          border-radius: 2px;
        }

        .icon {
          padding-right: 5px;
        }

        .textwrapper {
        }

        .label {
        }

        .sub {
          opacity: 0.5;
        }

        .activationlabel {
          opacity: 0.25;
        }

        .activation .activationlabel {
          opacity: 1;
          color: #${config.lib.stylix.colors.base0B};
        }

        .activation .textwrapper,
        .activation .icon,
        .activation .search {
          opacity: 0.5;
        }
      '';
    in {
      inherit style;
      enable = true;
      runAsService = true;
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
