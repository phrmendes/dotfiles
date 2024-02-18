{parameters, ...}: {
  services.syncthing = {
    inherit (parameters) user;
    enable = true;
    configDir = "${parameters.home}/.config/syncthing";
    dataDir = "${parameters.home}/.config/syncthing/db";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    relay.enable = true;
    settings = {
      options = {
        globalAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = 1;
      };
      folders = {
        "camera" = {
          path = "${parameters.home}/syncthing/camera";
          devices = ["phone" "desktop"];
        };
        "documents" = {
          path = "${parameters.home}/syncthing/documents";
          devices = ["phone" "desktop"];
        };
        "images" = {
          path = "${parameters.home}/syncthing/images";
          devices = ["desktop"];
        };
        "notes" = {
          path = "${parameters.home}/syncthing/notes";
          devices = ["phone" "tablet" "desktop"];
        };
        "ufabc" = {
          path = "${parameters.home}/syncthing/ufabc";
          devices = ["desktop" "tablet"];
        };
        "comics" = {
          path = "${parameters.home}/syncthing/library/comics";
          devices = ["desktop"];
        };
        "IT" = {
          path = "${parameters.home}/syncthing/library/IT";
          devices = ["desktop"];
        };
        "math" = {
          path = "${parameters.home}/syncthing/library/math";
          devices = ["desktop"];
        };
        "social_sciences" = {
          path = "${parameters.home}/syncthing/library/social_sciences";
          devices = ["desktop"];
        };
        "zotero" = {
          path = "${parameters.home}/syncthing/library/zotero";
          devices = ["phone" "desktop" "tablet"];
        };
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
        "desktop" = {
          id = "BVVRGXC-OXJER27-7MUSRIP-CTJAFUZ-4BOGJHK-GRIGAOG-AJUNZ2A-466MUAJ";
          autoAcceptFolders = true;
        };
      };
    };
  };
}
