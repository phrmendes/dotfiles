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
          path = "${parameters.home}/Documents/camera";
          devices = ["phone" "server"];
        };
        "documents" = {
          path = "${parameters.home}/Documents/documents";
          devices = ["phone" "server"];
        };
        "images" = {
          path = "${parameters.home}/Documents/images";
          devices = ["server"];
        };
        "notes" = {
          path = "${parameters.home}/Documents/notes";
          devices = ["phone" "tablet" "server"];
        };
        "ufabc" = {
          path = "${parameters.home}/Documents/ufabc";
          devices = ["server" "tablet"];
        };
        "comics" = {
          path = "${parameters.home}/Documents/library/comics";
          devices = ["server"];
        };
        "IT" = {
          path = "${parameters.home}/Documents/library/IT";
          devices = ["server"];
        };
        "math" = {
          path = "${parameters.home}/Documents/library/math";
          devices = ["server"];
        };
        "social_sciences" = {
          path = "${parameters.home}/Documents/library/social_sciences";
          devices = ["server"];
        };
        "zotero" = {
          path = "${parameters.home}/Documents/library/zotero";
          devices = ["phone" "server" "tablet"];
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
        "server" = {
          id = "Q4OBDSD-FEOKUZG-Y7KT6JO-A5UMSVO-EQVBZIO-DJZERPV-MHUTDAI-J72A7QL";
          autoAcceptFolders = true;
        };
      };
    };
  };
}
