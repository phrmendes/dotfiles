{ config, ... }:
let
  inherit (config) settings;
  versioning = {
    simple = {
      type = "simple";
      params = {
        keep = "10";
        cleanoutDays = "30";
      };
    };
    trashcan = {
      type = "trashcan";
      params.cleanoutDays = "15";
    };
  };
  workstations = [
    "desktop"
    "laptop"
    "server"
  ];
  withMobile = workstations ++ [
    "phone"
    "tablet"
  ];
  trashcanFolder = path: devices: {
    inherit path devices;
    versioning = versioning.trashcan;
  };
in
{
  flake.modules.nixos.syncthingServer =
    { config, lib, ... }:
    let
      port = 8384;
    in
    {
      users.users.syncthing.extraGroups = [ "external" ];

      homepage.services.syncthing = {
        url = "syncthing.${config.caddy.domain}";
        homepage = {
          name = "Syncthing";
          description = "File synchronisation";
          icon = "sh-syncthing";
          category = "Services";
        };
      };

      systemd.tmpfiles.rules =
        let
          syncDir = name: "d /mnt/external/syncthing/${name} 2775 ${settings.user} external -";
          folders = [
            "antennapod"
            "collections"
            "documents"
            "excalidraw"
            "images"
            "keepassxc"
            "notes"
            "reading"
            "ufabc"
          ];
        in
        [
          "d /mnt/external/syncthing 2775 ${settings.user} external -"
          "d /var/lib/syncthing 0750 syncthing syncthing -"
          "d /var/lib/syncthing/.config 0750 syncthing syncthing -"
          "d /var/lib/syncthing/.config/syncthing 0750 syncthing syncthing -"
        ]
        ++ map syncDir folders;

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          22000
          21027
        ];
      };

      systemd.services.syncthing = {
        unitConfig.RequiresMountsFor = [ "/mnt/external" ];
        serviceConfig.UMask = "0002";
      };

      services = {
        restic.backups.syncthing = config.restic.mkBackup "syncthing" {
          paths = [ "/mnt/external/syncthing" ];
          exclude = [
            "/mnt/external/syncthing/reading"
            "/mnt/external/syncthing/files"
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
              removeAttrs settings.syncthingDevices [ "server" ]
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
                reading = {
                  path = "/mnt/external/syncthing/reading";
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

  flake.modules.nixos.syncthingWorkstation =
    { lib, ... }:
    {
      services.syncthing = {
        inherit (settings) user;
        enable = true;
        configDir = "${settings.home}/.config/syncthing";
        openDefaultPorts = true;
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          options = {
            localAnnounceEnabled = true;
            urAccepted = 1;
          };
          devices = lib.mapAttrs (_: id: { inherit id; }) settings.syncthingDevices;
          folders = {
            "documents" = trashcanFolder "${settings.home}/Documents/documents" workstations;
            "images" = trashcanFolder "${settings.home}/Pictures/images" workstations;
            "notes" = {
              path = "${settings.home}/Documents/notes";
              versioning = versioning.simple;
              devices = withMobile;
            };
            "ufabc" = trashcanFolder "${settings.home}/Documents/ufabc" (workstations ++ [ "tablet" ]);
            "collections" = trashcanFolder "${settings.home}/Documents/collections" workstations;
            "excalidraw" = trashcanFolder "${settings.home}/Documents/excalidraw" workstations;
            "reading" = trashcanFolder "${settings.home}/Documents/reading" withMobile;
            "keepassxc" = trashcanFolder "${settings.home}/Documents/keepassxc" withMobile;
          };
        };
      };
    };
}
