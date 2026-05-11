{ config, ... }:
{
  modules.nixos.server.networking =
    { lib, config, ... }:
    {
      services.resolved.enable = lib.mkForce false;
      networking.resolvconf.enable = lib.mkForce false;
      networking.nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
    };
}
