{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.caddy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.utils) mkVhost;
      domain = config.caddy.domain;
      caStore = pkgs.writeTextDir "ca.crt" (builtins.readFile ../../../files/ca.crt);
    in
    {
      options.caddy = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = settings.serverDomain;
          readOnly = true;
        };
        mkVhost = lib.mkOption {
          type = lib.types.anything;
          readOnly = true;
          default = mkVhost config.caddy.domain;
        };
      };

      config = {
        age.secrets."ca.key" = config.utils.mkSecretReadable {
          file = ../../../secrets/ca.age.key;
          owner = "caddy";
        };

        networking.hosts."127.0.0.1" = [ "auth.${domain}" ];

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services.caddy = {
          enable = true;
          virtualHosts = {
            "*.${domain}" = {
              extraConfig = ''
                respond "Not Found" 404
              '';
            };
            ${domain} = {
              extraConfig = ''
                handle /ca.crt {
                  root * ${caStore}
                  file_server
                }
                handle {
                  respond "Not Found" 404
                }
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
            local_certs
            pki {
              ca local {
                root {
                  cert ${../../../files/ca.crt}
                  key ${config.age.secrets."ca.key".path}
                }
              }
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
