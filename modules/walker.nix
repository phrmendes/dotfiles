{
  lib,
  config,
  ...
}: {
  options.walker.enable = lib.mkEnableOption "enable walker";

  config = lib.mkIf config.walker.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        ui = {
          h_align = "fill";
          v_align = "fill";
          anchors = {
            bottom = true;
            left = true;
            right = true;
            top = true;
          };
          window = {
            orientation = "horizontal";
            box = {
              h_align = "center";
              margins = {
                bottom = 200;
                top = 200;
              };
            };
          };
        };
      };
      theme = {
        style = with config.lib.stylix.colors.withHashtag;
        # css
          ''
            #window,
            #box,
            #search,
            #password,
            #input,
            #typeahead,
            #spinner,
            #list,
            child,
            scrollbar,
            slider,
            #item,
            #text,
            #label,
            #sub,
            #activationlabel {
              all: unset;
            }

            #window {
              background: none;
            }

            #box {
              background: ${base01};
              padding: 16px;
              border-radius: 8px;
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
            }

            scrollbar {
              background: none;
              padding-left: 8px;
            }

            slider {
              min-width: 2px;
              background: ${base02};
              opacity: 0.5;
            }

            #search {
              padding-bottom: 10px;
            }

            #password,
            #input,
            #typeahead {
              background: ${base01};
              background: none;
              box-shadow: none;
              border-radius: 0px;
              border-radius: 32px;
              color: ${base07};
              padding-left: 12px;
              padding-right: 12px;
            }

            #input {
              background: none;
            }

            #input > *:first-child,
            #typeahead > *:first-child {
              color: ${base02};
              margin-right: 7px;
            }

            #input > *:last-child,
            #typeahead > *:last-child {
              color: ${base02};
            }

            #spinner {
            }

            #typeahead {
              color: ${base0D};
            }

            #input placeholder {
              opacity: 0.5;
            }

            #list {
            }

            child {
              border-radius: 8px;
              color: ${base07};
              padding: 4px;
            }

            child:selected,
            child:hover {
              background: ${base03};
              box-shadow: none;
              color: ${base07};
            }

            #item {
            }

            #icon {
              padding-right: 5px;
            }

            #text {
            }

            #label {
              font-weight: bold;
              color: ${base07};
            }

            #sub {
              opacity: 0.5;
              color: ${base07};
            }

            #activationlabel {
              opacity: 0.5;
              padding-right: 4px;
            }

            .activation #activationlabel {
              font-weight: bold;
              color: ${base0D};
              opacity: 1;
            }

            .activation #text,
            .activation #icon,
            .activation #search {
            }
          '';
      };
    };
  };
}
