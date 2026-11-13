{
  flake.modules.homeManager.bash =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs = {
        atuin.enableBashIntegration = false;
        eza = {
          enable = true;
          enableNushellIntegration = false;
        };
        bash.initExtra = lib.mkMerge [
          (lib.mkOrder 50 ''
            source ${pkgs.blesh}/share/blesh/ble.sh --noattach --rcfile ${pkgs.writeText "blerc" ''
              ble-face auto_complete=fg=8
              ble-face region_insert=bg=8
              ble-face region_target=bg=8
              ble-face menu_filter_input=bg=8
            ''}
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
