{ pkgs, config, ... }:
{
  services = {
    envfs.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    ntpd-rs.enable = true;
    resolved.enable = true;
    udev.enable = true;

    gnome = {
      gnome-keyring.enable = true;
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
      authKeyParameters = {
        ephemeral = false;
        preauthorized = true;
      };
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      allowSFTP = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        PubKeyAuthentication = true;
      };
    };

    xserver = {
      enable = true;
      autorun = true;
      excludePackages = with pkgs; [ xterm ];
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
