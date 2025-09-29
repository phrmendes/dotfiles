{ parameters, ... }:
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
  services.syncthing = {
    inherit (parameters) user;
    configDir = "${parameters.home}/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
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
          id = "V3YDAIH-HZAJKMP-GZEYKK4-WEA4F2H-MSVSXFA-6XUTGTF-XSXCSG7-TRFW5AZ";
          autoAcceptFolders = true;
        };
        "laptop" = {
          id = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "camera" = {
          path = "${parameters.home}/Pictures/camera";
          versioning = versioning.trashcan;
          devices = [
            "phone"
            "server"
          ];
        };
        "documents" = {
          path = "${parameters.home}/Documents/documents";
          versioning = versioning.trashcan;
          devices = [
            "desktop"
            "laptop"
            "server"
          ];
        };
        "images" = {
          path = "${parameters.home}/Pictures/images";
          versioning = versioning.trashcan;
          devices = [
            "desktop"
            "laptop"
            "server"
          ];
        };
        "notes" = {
          path = "${parameters.home}/Documents/notes";
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
          path = "${parameters.home}/Documents/ufabc";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "desktop"
            "laptop"
          ];
        };
        "zotero" = {
          path = "${parameters.home}/Documents/zotero";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "tablet"
            "desktop"
            "laptop"
          ];
        };
        "collections" = {
          path = "${parameters.home}/Documents/collections";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "desktop"
            "laptop"
          ];
        };
        "excalidraw" = {
          path = "${parameters.home}/Documents/excalidraw";
          versioning = versioning.trashcan;
          devices = [
            "server"
            "desktop"
            "laptop"
          ];
        };
        "keepassxc" = {
          path = "${parameters.home}/Documents/keepassxc";
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
}
