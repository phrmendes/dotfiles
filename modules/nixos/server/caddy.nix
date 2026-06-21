{ config, ... }:
let
  inherit (config) settings dotfilesLib;
in
{
  modules.nixos.server.caddy =
    {
      lib,
      config,
      ...
    }:
    let
      domain = config.server.caddy.domain;
    in
    {
      options.server.caddy = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "local.phrmendes.xyz";
          readOnly = true;
        };

        mkVhost = lib.mkOption {
          type = lib.types.anything;
          readOnly = true;
          default = dotfilesLib.mkVhost domain;
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        security.acme = {
          acceptTerms = true;
          defaults.email = settings.email;
          certs."${domain}" = {
            inherit domain;
            extraDomainNames = [ "*.${domain}" ];
            dnsProvider = "desec";
            dnsResolver = "ns1.desec.io:53";
            environmentFile = config.age.secrets."caddy.env".path;
            group = config.services.caddy.group;
            reloadServices = [ "caddy.service" ];
          };
        };

        services.caddy = {
          enable = true;
          inherit (settings) email;
          virtualHosts = {
            "http://${domain}" = {
              extraConfig = "redir https://{host}{uri}";
            };
            "http://*.${domain}" = {
              extraConfig = "redir https://{host}{uri}";
            };
          };
          globalConfig = "auto_https off";

          extraConfig = ''
            (security-headers) {
              header {
                Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                X-Content-Type-Options "nosniff"
                X-Frame-Options "DENY"
                X-XSS-Protection "1; mode=block"
                Referrer-Policy "strict-origin-when-cross-origin"
                -Server
              }
            }
          '';
        };
      };
    };
}
