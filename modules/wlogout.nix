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
            font-family: "Fira Sans Semibold";
        	background-image: none;
        	transition: 20ms;
        	box-shadow: none;
        }

        button {
        	color: #${config.lib.stylix.colors.base00}
            font-size:20px;
            background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;
        	border-style: solid;
        	background-color: #${config.lib.stylix.colors.base00};
        	border: 3px solid #${config.lib.stylix.colors.base00};
            box-shadow: #${config.lib.stylix.colors.base00};
        }

        button:focus,
        button:active,
        button:hover {
            color: #${config.lib.stylix.colors.base03};
        	background-color: #${config.lib.stylix.colors.base00};
        	border: #${config.lib.stylix.colors.base00};
        }

        #lock {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/lock.png}));
        }

        #logout {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/logout.png}));
        }

        #suspend {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/suspend.png}));
        }

        #hibernate {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/hibernate.png}));
        }

        #shutdown {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/shutdown.png}));
        }

        #reboot {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url(${../dotfiles/wlogout/icons/reboot.png}));
        }
      '';
    };
  };
}
