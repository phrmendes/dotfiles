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
        "d /mnt/external 2775 1000 1000 -"
        "d /mnt/external/downloads 2775 1000 1000 -"
        "d /mnt/external/downloads/.incomplete 2775 1000 1000 -"
        "d /mnt/external/movies 2775 1000 1000 -"
        "d /mnt/external/tvshows 2775 1000 1000 -"
        "d /var/lib/docker/volumes 2775 1000 1000 -"
      ];
    };
  };
}
