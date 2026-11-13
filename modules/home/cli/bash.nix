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
        carapace.enableBashIntegration = false;
        eza = {
          enable = true;
          enableNushellIntegration = false;
        };
        bash.initExtra = lib.mkMerge [
          (lib.mkOrder 50 ''
            source ${pkgs.blesh}/share/blesh/ble.sh --noattach --rcfile ${pkgs.writeText "blerc" ''
              bleopt complete_auto_complete=
              ble-face region_insert=bg=8
              ble-face region_target=bg=8
              ble-face menu_filter_input=bg=8
            ''}
          '')
          (lib.mkOrder 850 ''
            source <(${lib.getExe config.programs.carapace.package} _carapace bash | ${lib.getExe pkgs.gnused} 's/ read -r -d/ builtin read -r -d/')
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
