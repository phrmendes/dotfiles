{
  flake.modules.homeManager.blesh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs = {
        atuin.enableBashIntegration = false;
        bash.initExtra = lib.mkMerge [
          (lib.mkOrder 50 ''
            source ${pkgs.blesh}/share/blesh/ble.sh --noattach
          '')
          (lib.mkOrder 900 ''
            eval "$(${lib.getExe config.programs.atuin.package} init bash ${lib.escapeShellArgs config.programs.atuin.flags})"
          '')
          (lib.mkOrder 10000 ''
            [[ ''${BLE_VERSION-} ]] && ble-attach
          '')
        ];
      };
    };
}
