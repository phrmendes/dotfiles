_: {
  modules.nixos.core.services =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      services = {
        envfs.enable = true;
        fstrim.enable = true;
        gvfs.enable = lib.mkIf (config.machine.type != "server" && config.machine.type != "container") true;
        ntpd-rs.enable = true;
        udev.enable = lib.mkIf (config.machine.type != "container") true;
        geoclue2.enable = lib.mkIf (
          config.machine.type != "server" && config.machine.type != "container"
        ) true;

        gnome = {
          gnome-keyring.enable = false;
          gcr-ssh-agent.enable = false;
        };

        journald.extraConfig = "SystemMaxUse=1G";

        btrfs.autoScrub = lib.mkIf (config.machine.type != "container") {
          enable = true;
          interval = "monthly";
        };

        dbus.packages = with pkgs; [ gcr ];

        tailscale.enable = true;

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
