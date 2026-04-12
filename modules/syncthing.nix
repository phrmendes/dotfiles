{ config, ... }:
let
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
in
{
  modules.nixos.workstation.syncthing = {
    services.syncthing = {
      inherit (config.settings) user;
      enable = true;
      configDir = "${config.settings.home}/.config/syncthing";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        options = {
          localAnnounceEnabled = true;
          urAccepted = 1;
        };
        devices = {
          "phone" = {
            id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
            autoAcceptFolders = true;
          };
          "tablet" = {
            id = "ME77KQY-MGUM34F-M6RI4DI-EPNNS2P-FSPEYB6-2XUHYZB-5MGG7BV-XJTGAQO";
            autoAcceptFolders = true;
          };
          "server" = {
            id = "WIPV7YV-QSYVBJX-IXFX5RA-DPZGVFX-VCA5K3S-3EZ6CN4-J36EY5S-HCZUMAG";
            autoAcceptFolders = true;
          };
          "desktop" = {
            id = "GX2DVTR-JHGAK4J-FSWUSWO-T6LXWWV-M7KWB6C-RQHO3YA-XCRMS3P-76YHUAG";
            autoAcceptFolders = true;
          };
          "laptop" = {
            id = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
            autoAcceptFolders = true;
          };
        };
        folders = {
          "documents" = {
            path = "${config.settings.home}/Documents/documents";
            versioning = versioning.trashcan;
            devices = [
              "desktop"
              "laptop"
              "server"
            ];
          };
          "images" = {
            path = "${config.settings.home}/Pictures/images";
            versioning = versioning.trashcan;
            devices = [
              "desktop"
              "laptop"
              "server"
            ];
          };
          "notes" = {
            path = "${config.settings.home}/Documents/notes";
            versioning = versioning.simple;
            devices = [
              "desktop"
              "laptop"
              "phone"
              "server"
              "tablet"
            ];
          };
          "ufabc" = {
            path = "${config.settings.home}/Documents/ufabc";
            versioning = versioning.trashcan;
            devices = [
              "server"
              "desktop"
              "laptop"
            ];
          };
          "zotero" = {
            path = "${config.settings.home}/Documents/zotero";
            versioning = versioning.trashcan;
            devices = [
              "server"
              "tablet"
              "desktop"
              "laptop"
            ];
          };
          "collections" = {
            path = "${config.settings.home}/Documents/collections";
            versioning = versioning.trashcan;
            devices = [
              "server"
              "desktop"
              "laptop"
            ];
          };
          "excalidraw" = {
            path = "${config.settings.home}/Documents/excalidraw";
            versioning = versioning.trashcan;
            devices = [
              "server"
              "desktop"
              "laptop"
            ];
          };
          "keepassxc" = {
            path = "${config.settings.home}/Documents/keepassxc";
            versioning = versioning.trashcan;
            devices = [
              "server"
              "phone"
              "desktop"
              "laptop"
            ];
          };
        };
      };
    };
  };
}
