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
              devices = allDevices;
            };
            "ufabc" = trashcanFolder "${settings.home}/Documents/ufabc" (workstations ++ [ "tablet" ]);
            "collections" = trashcanFolder "${settings.home}/Documents/collections" workstations;
            "excalidraw" = trashcanFolder "${settings.home}/Documents/excalidraw" workstations;
            "reading" = trashcanFolder "${settings.home}/Documents/reading" allDevices;
            "keepassxc" = trashcanFolder "${settings.home}/Documents/keepassxc" allDevices;
          };
        };
      };
    };
}
