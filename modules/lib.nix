{ lib, ... }:
{
  options.dotfilesLib = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    readOnly = true;
    default = {
      mkBase16Lua =
        colors:
        lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null) colors.withHashtag
        |> lib.mapAttrsToList (name: value: ''${name} = "${value}"'')
        |> lib.concatStringsSep ",\n    ";
    };
  };
}
