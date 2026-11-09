{ config, inputs, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.nushell =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.sessionPath = [ "$HOME/.local/bin" ];

      programs.nushell = {
        enable = true;
        package = pkgs.local.nushell;
        settings = {
          show_banner = false;
          edit_mode = "vi";
          history.file_format = "sqlite";
        };
        environmentVariables = {
          DOCKER_HOST = lib.hm.nushell.mkNushellInline ''$"unix://($env.XDG_RUNTIME_DIR)/podman/podman.sock"'';
          DOCKER_SOCK = lib.hm.nushell.mkNushellInline ''$"($env.XDG_RUNTIME_DIR)/podman/podman.sock"'';
          PROMPT_INDICATOR_VI_INSERT = "";
          PROMPT_INDICATOR_VI_NORMAL = "";
          _ZO_MAXAGE = "100000";
        };
        shellAliases =
          let
            agenix = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          {
            bash = lib.getExe pkgs.bashInteractive;
            asr = "${lib.getExe pkgs.atuin} scripts run";
            cat = lib.getExe pkgs.bat;
            create-secret = "${lib.getExe pkgs.authelia} crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986";
            k = lib.getExe pkgs.kubectl;
            open-secret = "${lib.getExe' agenix "agenix"} -i ~/.ssh/age -e";
            unlock-server = "ssh server-unlock";
            v = "nvim";
            wake-server = "${lib.getExe pkgs.wakeonlan} ${settings.lan.serverMac}";
          };
        extraConfig = ''
          source ${../../../files/scripts/skim.nu}

          $env.config.menus = ($env.config.menus | each {|menu|
            if $menu.name in [completion_menu ide_completion_menu] {
              $menu | upsert marker "λ "
            } else {
              $menu
            }
          })
        '';
      };
    };
}
