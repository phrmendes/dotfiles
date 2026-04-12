{ config, ... }:
{
  modules.nixos.server = {
    persistence = {
      environment.persistence."/persist".users.${config.settings.user}.directories = [
        "dotfiles"
        ".config"
        ".ssh"
        ".local/share"
        ".local/state"
      ];
    };

    tailscale = {
      services.tailscale = {
        useRoutingFeatures = "both";
        extraSetFlags = [
          "--advertise-exit-node"
          "--accept-routes"
          "--advertise-routes=192.168.0.0/24"
        ];
      };
    };

    filesystems = {
      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/external";
        fsType = "ext4";
        options = [ "defaults" ];
      };

      systemd.tmpfiles.rules = [
        "d /run/sync 0700 ${config.settings.user} users -"
        "d /mnt/external 2775 ${config.settings.user} users -"
      ];
    };
  };
}
