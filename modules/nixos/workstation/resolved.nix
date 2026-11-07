{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.resolved = {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [ settings.lan.serverAddress ];
        Domains = [ "~${settings.serverDomain}" ];
        DNSSEC = "false";
        LLMNR = "false";
      };
    };
  };
}
