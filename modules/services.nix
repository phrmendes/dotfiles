_: {
  modules.nixos.core.services =
    { pkgs, config, lib, ... }:
    {
      services = {
        envfs.enable = true;
        fstrim.enable = true;
        gvfs.enable = lib.mkIf (config.machine.type != "server") true;
        ntpd-rs.enable = true;
        udev.enable = true;
        geoclue2.enable = lib.mkIf (config.machine.type != "server") true;

        gnome = {
          gnome-keyring.enable = false;
          gcr-ssh-agent.enable = false;
        };

        journald.extraConfig = "SystemMaxUse=1G";

        btrfs.autoScrub = {
          enable = true;
          interval = "monthly";
        };

        dbus.packages = with pkgs; [ gcr ];

        tailscale = {
          enable = true;
          authKeyFile = config.age.secrets.tailscale-authkey.path;
          extraUpFlags = [ "--advertise-tags=tag:main" ];
          authKeyParameters = {
            ephemeral = false;
            preauthorized = true;
          };
        };

        openssh = {
          enable = true;
          allowSFTP = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            PubKeyAuthentication = true;
          };
        };
      };
    };
}
