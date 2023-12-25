let
  user = "phrmendes";
  home = "/home/${user}";
  sync = "${home}/Documents";
in {
  services.syncthing = {
    enable = true;
    configDir = "${home}/.config/syncthing";
    dataDir = "${home}/.config/syncthing/db";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    user = "${user}";
    settings = {
      options.globalAnnounceEnabled = true;
      folders = {
        "camera" = {
          path = "${sync}/camera";
          devices = ["phone" "server"];
        };
        "documents" = {
          path = "${sync}/documents";
          devices = ["phone" "server"];
        };
        "images" = {
          path = "${sync}/images";
          devices = ["server"];
        };
        "notes" = {
          path = "${sync}/notes";
          devices = ["phone" "tablet" "server"];
        };
        "ufabc" = {
          path = "${sync}/ufabc";
          devices = ["server" "tablet"];
        };
        "comics" = {
          path = "${sync}/library/comics";
          devices = ["server"];
        };
        "IT" = {
          path = "${sync}/library/IT";
          devices = ["server"];
        };
        "math" = {
          path = "${sync}/library/math";
          devices = ["server"];
        };
        "social_sciences" = {
          path = "${sync}/library/social_sciences";
          devices = ["server"];
        };
        "zotero" = {
          path = "${sync}/library/zotero";
          devices = ["phone" "server" "tablet"];
        };
      };
      devices = {
        "phone" = {
          id = "BQ7RBNB-E7JHGKK-BNO7JTS-B4YWY7B-B6GB77X-WG6KH5A-F5SM24Z-ZDERGQ7";
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
