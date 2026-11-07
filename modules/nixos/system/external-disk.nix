{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.externalDisk =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.externalDisk;
    in
    {
      options.externalDisk = {
        device = lib.mkOption {
          type = lib.types.path;
          description = "Device of the external disk";
        };

        directories = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.str;
                  description = "Directory under /mnt/external";
                };
                owner = lib.mkOption {
                  type = lib.types.str;
                  default = settings.user;
                };
                group = lib.mkOption {
                  type = lib.types.str;
                  default = "external";
                };
                mode = lib.mkOption {
                  type = lib.types.str;
                  default = "2775";
                };
                age = lib.mkOption {
                  type = lib.types.str;
                  default = "-";
                };
              };
            }
          );
          default = [ ];
          description = "Directories to create under /mnt/external";
        };
      };

      config = {
        fileSystems."/mnt/external" = {
          inherit (cfg) device;
          fsType = "ext4";
          options = [
            "defaults"
            "noatime"
            "nofail"
          ];
        };

        systemd = {
          tmpfiles.rules = [
            "d /mnt/external 2775 ${settings.user} external -"
            "a+ /mnt/external - - - - d:g:external:rwx,g:external:rwx,d:group::rwx,group::rwx,d:mask::rwx,mask::rwx"
          ]
          ++ map (
            dir: "d /mnt/external/${dir.path} ${dir.mode} ${dir.owner} ${dir.group} ${dir.age}"
          ) cfg.directories;

          services.check-external = {
            description = "Check the external filesystem";
            serviceConfig.Type = "oneshot";
            script = ''
              ${pkgs.util-linux}/bin/mountpoint --quiet /mnt/external
              marker=/mnt/external/.health-check
              trap 'rm -f "$marker"' EXIT
              touch "$marker"
            '';
          };

          timers.check-external = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnActiveSec = "5m";
              OnUnitActiveSec = "1h";
              Unit = "check-external.service";
            };
          };
        };
      };
    };
}
