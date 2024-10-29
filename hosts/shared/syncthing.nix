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
      folders = let
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
      in {
        "camera" = {
          path = "${parameters.home}/Pictures/camera";
          devices = ["desktop" "orangepizero2" "phone"];
          versioning = versioning.trashcan;
        };
        "documents" = {
          path = "${parameters.home}/Documents/documents";
          devices = ["desktop" "laptop" "orangepizero2" "phone" "tablet"];
          versioning = versioning.trashcan;
        };
        "images" = {
          path = "${parameters.home}/Pictures/images";
          devices = ["orangepizero2" "laptop" "desktop"];
          versioning = versioning.trashcan;
        };
        "notes" = {
          path = "${parameters.home}/Documents/notes";
          devices = ["desktop" "laptop" "orangepizero2" "phone" "tablet"];
          versioning = versioning.simple;
        };
        "ufabc" = {
          path = "${parameters.home}/Documents/ufabc";
          devices = ["desktop" "laptop" "orangepizero2" "phone" "tablet"];
          versioning = versioning.trashcan;
        };
        "comics" = {
          path = "${parameters.home}/Documents/library/comics";
          devices = ["orangepizero2" "desktop"];
          versioning = versioning.trashcan;
        };
        "IT" = {
          path = "${parameters.home}/Documents/library/IT";
          devices = ["desktop" "laptop" "orangepizero2"];
          versioning = versioning.trashcan;
        };
        "math" = {
          path = "${parameters.home}/Documents/library/math";
          devices = ["desktop" "laptop" "orangepizero2"];
          versioning = versioning.trashcan;
        };
        "social_sciences" = {
          path = "${parameters.home}/Documents/library/social_sciences";
          devices = ["desktop" "laptop" "orangepizero2"];
          versioning = versioning.trashcan;
        };
        "zotero" = {
          path = "${parameters.home}/Documents/library/zotero";
          devices = ["desktop" "laptop" "orangepizero2" "phone" "tablet"];
          versioning = versioning.trashcan;
        };
        "tmuxp" = {
          path = "${parameters.home}/.config/tmuxp";
          devices = ["desktop" "laptop" "orangepizero2"];
          versioning = versioning.trashcan;
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
        "orangepizero2" = {
          id = "IBTRG42-EIAGPRC-747DP3E-LLWNQA5-XJOXWQT-HYVLC7R-Q5DCRLY-BXSQBQP";
          autoAcceptFolders = true;
        };
        "laptop" = {
          id = "DC7CVQK-XCQYE7F-JTW2JNJ-PQRSZOV-WU5GK5H-DZNX5VM-PU4HIKL-ZJUA5AX";
          autoAcceptFolders = true;
        };
        "desktop" = {
          id = "V3YDAIH-HZAJKMP-GZEYKK4-WEA4F2H-MSVSXFA-6XUTGTF-XSXCSG7-TRFW5AZ";
          autoAcceptFolders = true;
        };
      };
    };
  };
}
