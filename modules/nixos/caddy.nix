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
      inherit (config.utils) mkVhost;
      domain = config.caddy.domain;
    in
    {
      options.caddy = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "local.phrmendes.xyz";
          readOnly = true;
        };
        mkVhost = lib.mkOption {
          type = lib.types.anything;
          readOnly = true;
          default = mkVhost config.caddy.domain;
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services.caddy = {
          enable = true;
          inherit (settings) email;
          package = pkgs.local.caddy;
          environmentFile = config.age.secrets."caddy.env".path;
          virtualHosts = {
            "*.${domain}" = {
              extraConfig = ''
                tls {
                  dns desec {
                    token "{$DESEC_TOKEN}"
                  }
                }
                respond "Not Found" 404
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
              forward_auth 127.0.0.1:9099 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email

                @error status 401
                handle_response @error {
                  redir * https://auth.${domain}/?rd={scheme}://{host}{uri}
                }
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
    };
}
