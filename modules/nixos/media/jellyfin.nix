{
  flake.modules.nixos.jellyfin =
    { config, ... }:
    {
      homepage.services.jellyfin = {
        homepage = {
          name = "Jellyfin";
          description = "Media server";
          category = "Media";
        };
      };

      users.users.jellyfin.extraGroups = [
        "external"
        "render"
        "video"
      ];

      services = {
        jellyfin = {
          enable = true;
          openFirewall = true;
          forceEncodingConfig = true;
          hardwareAcceleration = {
            enable = true;
            type = "vaapi";
            device = "/dev/dri/renderD128";
          };
          transcoding = {
            enableHardwareEncoding = true;
            enableToneMapping = false;
            throttleTranscoding = true;
            hardwareDecodingCodecs = {
              h264 = true;
              hevc = true;
              hevc10bit = true;
              mpeg2 = true;
              vc1 = true;
              vp8 = true;
              vp9 = true;
            };
          };
        };
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "jellyfin";
          port = 8096;
        };
        restic.backups.jellyfin = config.restic.mkBackup "jellyfin" {
          paths = [ "/var/lib/jellyfin" ];
          exclude = [
            "/var/lib/jellyfin/metadata"
            "/var/lib/jellyfin/data/metadata"
            "/var/lib/jellyfin/data/transcodes"
            "/var/lib/jellyfin/cache"
            "/var/lib/jellyfin/log"
            "/var/lib/jellyfin/.cache"
          ];
          sqlite."/var/lib/jellyfin/data/jellyfin.db" = "library.sqlite";
        };
      };
    };
}
