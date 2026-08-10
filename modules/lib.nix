{
  nixosModules.dotfilesLib =
    { lib, ... }:
    {
      options.dotfilesLib = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        readOnly = true;
        default = {
          mkFirewallPort = port: {
            allowedTCPPorts = [ port ];
            allowedUDPPorts = [ port ];
          };

          mkSecretReadable =
            {
              file,
              owner ? "root",
              group ? "root",
              mode ? "0400",
              path ? null,
            }:
            {
              inherit
                file
                owner
                group
                mode
                ;
            }
            // lib.optionalAttrs (path != null) { inherit path; };

          mkBase16Lua =
            colors:
            lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null) colors.withHashtag
            |> lib.mapAttrsToList (name: value: ''${name} = "${value}"'')
            |> lib.concatStringsSep ",\n    ";

          mkVhost =
            domain:
            {
              name,
              port,
              extraConfig ? "",
              basicAuth ? null,
            }:
            {
              "${name}.${domain}" = {
                extraConfig = ''
                  ${extraConfig}

                  @websocket {
                    header Connection *Upgrade*
                    header Upgrade websocket
                  }

                  handle @websocket {
                    reverse_proxy 127.0.0.1:${toString port}
                  }

                  handle {
                    ${lib.optionalString (basicAuth != null) "import authelia-auth"}
                    reverse_proxy 127.0.0.1:${toString port} {
                      ${lib.optionalString (
                        basicAuth != null
                      ) ''header_up Authorization "Basic {\$BASIC_AUTH_${basicAuth}}"
                      header_down -WWW-Authenticate''}
                    }
                    import security-headers
                  }
                '';
              };
            };
        };
      };
    };
}
