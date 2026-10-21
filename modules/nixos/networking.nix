{
  flake.modules.nixos.networking =
    { lib, ... }:
    {
      networking = {
        resolvconf = {
          enable = true;
          extraConfig = "resolv_conf_local_only=NO";
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
