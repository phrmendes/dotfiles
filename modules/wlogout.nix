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
    };
  };
}
