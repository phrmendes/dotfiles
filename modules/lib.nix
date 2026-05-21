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

      mkSecret = user: file: mode: {
        inherit file mode;
        owner = user;
        group = "users";
      };

      mkSecretReadable = user: file: {
        inherit file;
        mode = "0440";
        owner = user;
        group = "users";
      };

      mkBase16Lua =
        colors:
        lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null) colors.withHashtag
        |> lib.mapAttrsToList (name: value: ''${name} = "${value}"'')
        |> lib.concatStringsSep ",\n    ";

      mkVhost = domain: name: port: {
        "${name}.${domain}" = {
          useACMEHost = domain;
          extraConfig = ''
            reverse_proxy 127.0.0.1:${toString port}
            import security-headers
          '';
        };
      };

      mkGoogleCloudSdk =
        google-cloud-sdk:
        google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
    };
  };
}
