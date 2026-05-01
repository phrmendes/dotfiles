_: {
  modules.nixos.core.services =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (config.machine) isWorkstation isContainer;
    in
    {
      services = {
        envfs.enable = true;
        fstrim.enable = true;
        gvfs.enable = isWorkstation;
        ntpd-rs.enable = true;
        udev.enable = !isContainer;
        geoclue2.enable = isWorkstation;

        gnome = {
          gnome-keyring.enable = false;
          gcr-ssh-agent.enable = false;
        };

        journald.extraConfig = "SystemMaxUse=1G";

        btrfs.autoScrub = lib.mkIf (!isContainer) {
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
