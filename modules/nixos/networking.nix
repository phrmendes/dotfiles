{
  nixosModules.networking =
    { lib, ... }:
    {
      networking = {
        resolvconf = {
          enable = true;
          extraOptions = [
            "timeout:1"
            "attempts:1"
          ];
        };
        networkmanager.dns = "none";
        nameservers = lib.mkDefault [
          "127.0.0.1"
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
}
