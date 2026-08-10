{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.caddy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      domain = config.caddy.domain;
    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.caddy = {
        enable = true;
        inherit (settings) email;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/desec@v1.1.0" ];
          hash = "sha256-sy924nxkritb+DzfyI2VJowYK8JyCHQyfXCmtiFDI2w=";
        };
        environmentFile = config.age.secrets."caddy.env".path;
        virtualHosts = {
          "auth.${domain}" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:9091
              import security-headers
            '';
          };
          "http://${domain}" = {
            extraConfig = "redir https://{host}{uri}";
          };
          "http://*.${domain}" = {
            extraConfig = "redir https://{host}{uri}";
          };
        };

        globalConfig = ''
          acme_dns desec {
            token "{$DESEC_TOKEN}"
          }
        '';

        extraConfig = ''
          (authelia-auth) {
            forward_auth 127.0.0.1:9091 {
              uri /api/authz/forward-auth
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
          }

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
}
