{ lib }:
{
  dependsOnPostgres = {
    after = [ "postgresql.target" ];
    requires = [ "postgresql.target" ];
  };

  mkPostgres = name: {
    ensureDatabases = [ name ];
    ensureUsers = [
      {
        inherit name;
        ensureDBOwnership = true;
      }
    ];
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

  mkOutput = m: {
    output = {
      _args = [ m.name ];
      mode = "${m.resolution}@${toString m.refreshRate}";
      position._props = {
        inherit (m) x y;
      };
      inherit (m) scale;
    };
  };

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
      auth ? false,
      extraConfig ? "",
      upstream ? "127.0.0.1:${toString port}",
      insecure ? false,
    }:
    let
      proxy =
        if insecure then
          "reverse_proxy ${upstream} { transport http { tls_insecure_skip_verify } }"
        else
          "reverse_proxy ${upstream}";
    in
    {
      "${name}.${domain}" = {
        extraConfig = ''
          ${extraConfig}

          @websocket {
            header Connection *Upgrade*
            header Upgrade websocket
          }

          handle @websocket {
            ${lib.optionalString auth "import authelia-auth"}
            ${proxy}
          }

          handle {
            ${lib.optionalString auth "import authelia-auth"}
            ${proxy}
            import security-headers
          }
        '';
      };
    };
}
