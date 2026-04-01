{ lib, config, ... }:
{
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file =
      let
        scripts = ../../files/scripts |> builtins.readDir |> builtins.attrNames;
        executables = builtins.listToAttrs (
          map (name: {
            name = ".local/bin/${name}" |> builtins.replaceStrings [ ".sh" ] [ "" ];
            value = {
              executable = true;
              source = ../../files/scripts/${name};
            };
          }) scripts
        );
      in
      {
        ".face.icon".source = ../../files/face.png;
      }
      // executables;
  };
}
