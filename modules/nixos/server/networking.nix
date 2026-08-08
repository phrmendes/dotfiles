{
  modules.nixos.server.networking =
    { lib, ... }:
    {
      services = {
        resolved.enable = lib.mkForce false;
        tailscale.extraUpFlags = [ "--accept-dns=false" ];
      };
      networking = {
        resolvconf.enable = lib.mkForce false;
        networkmanager.dns = lib.mkForce "none";
        nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
}
