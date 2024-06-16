{
  lib,
  config,
  ...
}: {
  options.wlogout.enable = lib.mkEnableOption "enable wlogout";

  config = lib.mkIf config.wlogout.enable {
    programs.wlogout = {
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
            background-image: none;
            box-shadow: none;
            font-family: "Fira Sans Semibold";
            transition: 20ms;
        }

        window {
            background-color: #${config.lib.stylix.colors.base00};
        }

        button {
            background-color: #${config.lib.stylix.colors.base00};
            background-position: center;
            background-repeat: no-repeat;
            background-size: 25%;
            border-color: #${config.lib.stylix.colors.base00};
            border-radius: 20px;
            border-style: solid;
            color: #${config.lib.stylix.colors.base07};
            text-decoration-color: #${config.lib.stylix.colors.base07};
        }

        button:focus, button:active, button:hover {
            background-color: #${config.lib.stylix.colors.base03};
            outline-style: none;
            border-radius: 20px;
        }

        #lock {
            background-image: image(url(${../dotfiles/wlogout/icons/lock.png}));
        }

        #logout {
            background-image: image(url(${../dotfiles/wlogout/icons/logout.png}));
        }

        #suspend {
            background-image: image(url(${../dotfiles/wlogout/icons/suspend.png}));
        }

        #hibernate {
            background-image: image(url(${../dotfiles/wlogout/icons/hibernate.png}));
        }

        #shutdown {
            background-image: image(url(${../dotfiles/wlogout/icons/shutdown.png}));
        }

        #reboot {
            background-image: image(url(${../dotfiles/wlogout/icons/reboot.png}));
        }
      '';
    };
  };
}
