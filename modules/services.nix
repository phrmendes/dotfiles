_: {
  modules.nixos.core.services =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      isWorkstation = config.machine.type == "desktop" || config.machine.type == "laptop";
      isNotContainer = config.machine.type != "container";
    in
    {
      services = {
        envfs.enable = true;
        fstrim.enable = true;
        gvfs.enable = isWorkstation;
        ntpd-rs.enable = true;
        udev.enable = isNotContainer;
        geoclue2.enable = isWorkstation;

        gnome = {
          gnome-keyring.enable = false;
          gcr-ssh-agent.enable = false;
        };

        journald.extraConfig = "SystemMaxUse=1G";

        btrfs.autoScrub = lib.mkIf isNotContainer {
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
