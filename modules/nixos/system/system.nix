{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.system =
    { pkgs, ... }:
    {

      age.identityPaths = [ "/persist${settings.home}/.ssh/age" ];

      networking.networkmanager.enable = true;

      security.pki.certificateFiles = [ ../../../files/ca.crt ];
      virtualisation.containers.enable = true;
      services = {
        dbus.packages = with pkgs; [ gcr_4 ];
        udev.enable = true;
        envfs.enable = false;
        fstrim.enable = true;
        ntpd-rs.enable = true;
        smartd = {
          enable = true;
          notifications.wall.enable = true;
        };

        gnome = {
          gcr-ssh-agent.enable = false;
          gnome-keyring.enable = false;
        };

        btrfs.autoScrub = {
          enable = true;
          interval = "monthly";
        };
      };

    };
}
