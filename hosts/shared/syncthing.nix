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
    };
  };
}
