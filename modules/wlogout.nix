{
  lib,
  config,
  pkgs,
  ...
}: {
  options.wlogout.enable = lib.mkEnableOption "enable wlogout";

  config = lib.mkIf config.wlogout.enable {
    programs.wlogout = let
      image = name: ''
        #${name} {
            background-image: image(
              url("${../dotfiles/wlogout/icons/${name}.png}"),
              url("${pkgs.wlogout}/share/wlogout/icons/${name}.svg}")
            );
        }
      '';
    in {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock (l)";
          keybind = "l";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown (s)";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend (z)";
          keybind = "z";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot (r)";
          keybind = "r";
        }
        {
          label = "logout";
          action = "loginctl terminate-session $USER";
          text = "Logout (o)";
          keybind = "o";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate (h)";
          keybind = "h";
        }
      ];
      style = ''
        * {
            background: none;
        }

        window {
            color: #${config.lib.stylix.colors.base07};
            background-color: #${config.lib.stylix.colors.base00};
        }

        button {
            color: #${config.lib.stylix.colors.base07};
            background-color: #${config.lib.stylix.colors.base00};
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
        }

        button:focus, button:active, button:hover {
            background-color: #${config.lib.stylix.colors.base03};
            outline-style: none;
        }

        ${lib.concatMapStringsSep "\n" image [
          "lock"
          "logout"
          "suspend"
          "hibernate"
          "shutdown"
          "reboot"
        ]}
      '';
    };
  };
}
