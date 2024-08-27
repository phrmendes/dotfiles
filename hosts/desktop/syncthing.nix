{parameters, ...}: {
  services.syncthing = {
    settings = {
      folders = {
        "camera" = {
          path = "${parameters.home}/Documents/camera";
          devices = ["phone" "server" "laptop"];
        };
        "documents" = {
          path = "${parameters.home}/Documents/documents";
          devices = ["phone" "server" "laptop"];
        };
        "images" = {
          path = "${parameters.home}/Documents/images";
          devices = ["server" "laptop"];
        };
        "notes" = {
          path = "${parameters.home}/Documents/notes";
          devices = ["phone" "tablet" "server" "laptop"];
        };
        "ufabc" = {
          path = "${parameters.home}/Documents/ufabc";
          devices = ["server" "tablet" "laptop"];
        };
        "comics" = {
          path = "${parameters.home}/Documents/library/comics";
          devices = ["server"];
        };
        "IT" = {
          path = "${parameters.home}/Documents/library/IT";
          devices = ["server" "laptop"];
        };
        "math" = {
          path = "${parameters.home}/Documents/library/math";
          devices = ["server" "laptop"];
        };
        "social_sciences" = {
          path = "${parameters.home}/Documents/library/social_sciences";
          devices = ["server" "laptop"];
        };
        "zotero" = {
          path = "${parameters.home}/Documents/library/zotero";
          devices = ["phone" "server" "tablet" "laptop"];
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
          id = "VH6IWI6-D5E666H-4S2D7XJ-AVHD2XW-7UC64AS-APTOCPU-LB3SB52-S5722Q5";
          autoAcceptFolders = true;
        };
        "laptop" = {
          id = "DC7CVQK-XCQYE7F-JTW2JNJ-PQRSZOV-WU5GK5H-DZNX5VM-PU4HIKL-ZJUA5AX";
          autoAcceptFolders = true;
        };
      };
    };
  };
}
