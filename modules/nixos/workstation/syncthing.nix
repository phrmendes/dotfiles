{ config, ... }:
let
  inherit (config.settings) home;
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
  allDevices = workstations ++ [
    "phone"
    "tablet"
  ];
  trashcanFolder = path: devices: {
    inherit path devices;
    versioning = versioning.trashcan;
  };
in
{
  modules.nixos.workstation.syncthing = {
    services.syncthing = {
      inherit (config.settings) user;
      enable = true;
      configDir = "${home}/.config/syncthing";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        options = {
          localAnnounceEnabled = true;
          urAccepted = 1;
        };
        devices = {
          "phone".id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
          "tablet".id = "N6ESTXQ-B2CWCVM-SHBRV7Y-KOP5JE5-P7CQJ2Q-LQIILS3-NWMBIBU-TTJ74QG";
          "server".id = "WIPV7YV-QSYVBJX-IXFX5RA-DPZGVFX-VCA5K3S-3EZ6CN4-J36EY5S-HCZUMAG";
          "desktop".id = "GX2DVTR-JHGAK4J-FSWUSWO-T6LXWWV-M7KWB6C-RQHO3YA-XCRMS3P-76YHUAG";
          "laptop".id = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
        };
        folders = {
          "documents" = trashcanFolder "${home}/Documents/documents" workstations;
          "images" = trashcanFolder "${home}/Pictures/images" workstations;
          "notes" = {
            path = "${home}/Documents/notes";
            versioning = versioning.simple;
            devices = allDevices;
          };
          "ufabc" = trashcanFolder "${home}/Documents/ufabc" (workstations ++ [ "tablet" ]);
          "collections" = trashcanFolder "${home}/Documents/collections" workstations;
          "excalidraw" = trashcanFolder "${home}/Documents/excalidraw" workstations;
          "reading" = trashcanFolder "${home}/Documents/reading" allDevices;
          "keepassxc" = trashcanFolder "${home}/Documents/keepassxc" allDevices;
        };
      };
    };
  };
}
