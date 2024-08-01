{
  lib,
  config,
  pkgs,
  ...
}: {
  options.wlogout.enable = lib.mkEnableOption "enable wlogout";

  config = lib.mkIf config.wlogout.enable {
    programs.wlogout = let
      inherit (lib) getExe;
      swaylock = getExe pkgs.swaylock;
      image = name: ''
        #${name} {
            background-image: image(
              url("${../dotfiles/wlogout/${name}.png}"),
              url("${pkgs.wlogout}/share/wlogout/${name}.svg}")
            );
        }
      '';
    in {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "${swaylock}";
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
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot (r)";
          keybind = "r";
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
          "shutdown"
          "reboot"
        ]}
      '';
    };
  };
}
