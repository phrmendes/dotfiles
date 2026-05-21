{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.syncthing =
    { config, ... }:
    let
      port = 8384;
    in
    {
      users.users.syncthing.extraGroups = [ "media" ];

      server.homepage.services.syncthing = {
        dataDir = "/srv/syncthing";
        url = "syncthing.${config.server.caddy.domain}";
        monitoredServices = [ "syncthing" ];
        homepage = {
          name = "Syncthing";
          description = "File synchronisation";
          icon = "sh-syncthing";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "syncthing" port;

      systemd.tmpfiles.rules = [
        "d /mnt/external/syncthing 2775 ${settings.user} media -"
        "d /srv/syncthing 0750 syncthing syncthing -"
        "d /srv/syncthing/.config 0750 syncthing syncthing -"
        "d /srv/syncthing/.config/syncthing 0750 syncthing syncthing -"
      ];

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          22000
          21027
        ];
      };

      services.syncthing = {
        enable = true;
        dataDir = "/srv/syncthing";
        configDir = "/srv/syncthing/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          gui = {
            address = "127.0.0.1:${toString port}";
            insecureSkipHostcheck = true;
          };

          options = {
            globalAnnounceEnabled = true;
            localAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          devices = {
            desktop = {
              id = "GX2DVTR-JHGAK4J-FSWUSWO-T6LXWWV-M7KWB6C-RQHO3YA-XCRMS3P-76YHUAG";
              autoAcceptFolders = false;
            };
            laptop = {
              id = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
              autoAcceptFolders = false;
            };
            phone = {
              id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
              introducer = true;
              autoAcceptFolders = false;
            };
            tablet = {
              id = "N6ESTXQ-B2CWCVM-SHBRV7Y-KOP5JE5-P7CQJ2Q-LQIILS3-NWMBIBU-TTJ74QG";
              autoAcceptFolders = false;
            };
          };

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
              };
              camera = {
                path = "/mnt/external/syncthing/camera";
                devices = [
                  "laptop"
                  "phone"
                ];
              };
              collections = {
                path = "/mnt/external/syncthing/collections";
                devices = [
                  "desktop"
                  "laptop"
                ];
              };
              documents = {
                path = "/mnt/external/syncthing/documents";
                devices = [
                  "desktop"
                  "laptop"
                ];
              };
              excalidraw = {
                path = "/mnt/external/syncthing/excalidraw";
                devices = [
                  "desktop"
                  "laptop"
                ];
              };
              images = {
                path = "/mnt/external/syncthing/images";
                devices = [
                  "desktop"
                  "laptop"
                ];
              };
              keepassxc = {
                path = "/mnt/external/syncthing/keepassxc";
                devices = allDevices;
              };
              notes = {
                path = "/mnt/external/syncthing/notes";
                devices = allDevices;
              };
              reading = {
                path = "/mnt/external/syncthing/reading";
                devices = allDevices;
              };
              ufabc = {
                path = "/mnt/external/syncthing/ufabc";
                devices = allDevices;
              };
            };
        };
      };
    };
}
