{
  flake.modules.nixos.syncthingServer =
    { config, lib, ... }:
    let
      inherit (config.utils) syncthingDevices;
      port = 8384;
      folders = [
        "antennapod"
        "collections"
        "documents"
        "excalidraw"
        "images"
        "keepassxc"
        "notes"
        "ufabc"
      ];
    in
    {
      users.users.syncthing.extraGroups = [ "external" ];

      homepage.services.syncthing = {
        siteMonitor = "http://127.0.0.1:${toString port}";
        homepage = {
          name = "Syncthing";
          description = "File synchronisation";
          category = "Services";
        };
      };

      externalDisk.directories = [
        { path = "syncthing"; }
      ]
      ++ map (name: { path = "syncthing/${name}"; }) folders;

      systemd.tmpfiles.rules = [
        "d /var/lib/syncthing 0750 syncthing syncthing -"
        "d /var/lib/syncthing/.config 0750 syncthing syncthing -"
        "d /var/lib/syncthing/.config/syncthing 0750 syncthing syncthing -"
      ];

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          22000
          21027
        ];
      };

      systemd.services.syncthing = {
        unitConfig.RequiresMountsFor = [ "/mnt/external" ];
        wantedBy = [ "mnt-external.mount" ];
        serviceConfig.UMask = "0002";
      };

      services = {
        restic.backups.syncthing = config.restic.mkBackup "syncthing" {
          paths = [
            "/mnt/external/syncthing"
            "/var/lib/syncthing"
          ];
          exclude = [
            "/mnt/external/syncthing/files"
            "/var/lib/syncthing/index-*.db"
          ];
        };
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "syncthing";
          inherit port;
          auth = true;
        };
        syncthing = {
          enable = true;
          overrideDevices = true;
          overrideFolders = true;
          settings = {
            gui = {
              address = "127.0.0.1:${toString port}";
              theme = "dark";
              insecureSkipHostcheck = true;
            };

            options = {
              globalAnnounceEnabled = true;
              localAnnounceEnabled = true;
              relaysEnabled = true;
              urAccepted = -1;
            };

            devices =
              removeAttrs syncthingDevices [ "server" ]
              |> lib.mapAttrs (
                name: id:
                {
                  inherit id;
                  autoAcceptFolders = false;
                }
                // lib.optionalAttrs (name == "phone") { introducer = true; }
              );

            folders =
              let
                allDevices = [
                  "desktop"
                  "laptop"
                  "phone"
                  "tablet"
                ];
              in
              {
                antennapod = {
                  path = "/mnt/external/syncthing/antennapod";
                  devices = [ "phone" ];
                  ignorePerms = true;
                };
                collections = {
                  path = "/mnt/external/syncthing/collections";
                  devices = [
                    "desktop"
                    "laptop"
                  ];
                  ignorePerms = true;
                };
                documents = {
                  path = "/mnt/external/syncthing/documents";
                  devices = [
                    "desktop"
                    "laptop"
                  ];
                  ignorePerms = true;
                };
                excalidraw = {
                  path = "/mnt/external/syncthing/excalidraw";
                  devices = [
                    "desktop"
                    "laptop"
                  ];
                  ignorePerms = true;
                };
                images = {
                  path = "/mnt/external/syncthing/images";
                  devices = [
                    "desktop"
                    "laptop"
                  ];
                  ignorePerms = true;
                };
                keepassxc = {
                  path = "/mnt/external/syncthing/keepassxc";
                  devices = allDevices;
                  ignorePerms = true;
                };
                notes = {
                  path = "/mnt/external/syncthing/notes";
                  devices = allDevices;
                  ignorePerms = true;
                };
                ufabc = {
                  path = "/mnt/external/syncthing/ufabc";
                  devices = allDevices;
                  ignorePerms = true;
                };
              };
          };
        };
      };
    };
}
