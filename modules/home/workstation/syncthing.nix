let
  workstations = [
    "desktop"
    "laptop"
    "server"
  ];
  withDeck = workstations ++ [ "deck" ];
  withMobile = withDeck ++ [
    "phone"
    "tablet"
  ];
  trashcanFolder = path: devices: {
    inherit path devices;
    versioning = {
      type = "trashcan";
      params.cleanoutDays = "15";
    };
  };
in
{
  flake.modules.homeManager.syncthing =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (import ../../../utils { inherit lib; }) syncthingDevices;
      homeDir = config.home.homeDirectory;
    in
    {
      services.syncthing = {
        enable = true;
        tray.enable = true;
        settings = {
          options = {
            localAnnounceEnabled = true;
            urAccepted = 1;
          };
          devices = lib.mapAttrs (_: id: { inherit id; }) syncthingDevices;
          folders = {
            documents = trashcanFolder "${homeDir}/Documents/documents" workstations;
            images = trashcanFolder "${homeDir}/Pictures/images" withDeck;
            ufabc = trashcanFolder "${homeDir}/Documents/ufabc" (withDeck ++ [ "tablet" ]);
            collections = trashcanFolder "${homeDir}/Documents/collections" withDeck;
            excalidraw = trashcanFolder "${homeDir}/Documents/excalidraw" withDeck;
            keepassxc = trashcanFolder "${homeDir}/Documents/keepassxc" withMobile;
            notes = {
              path = "${homeDir}/Documents/notes";
              devices = withMobile;
              versioning = {
                type = "simple";
                params = {
                  keep = "10";
                  cleanoutDays = "30";
                };
              };
            };
          };
        };
      };
    };
}
