{parameters, ...}: {
  services = {
    duplicati = {
      inherit (parameters) user;
      enable = true;
    };

    xserver.videoDrivers = ["nvidia"];
  };
}
