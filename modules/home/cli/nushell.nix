{ config, inputs, ... }:
let
  inherit (config) settings;
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

      programs.carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

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
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          PI_CACHE_RETENTION = "long";
          PI_NUSHELL_PATH = "${pkgs.local.nushell}/bin/nu";
          PI_SKIP_VERSION_CHECK = "1";
          PROMPT_COMMAND_RIGHT = "";
          _ZO_MAXAGE = "100000";
        };
        shellAliases =
          let
            agenix = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          {
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
          use ${pkgs.nu_scripts}/share/nu_scripts/modules/prompt/basic-git.nu basic-git-left-prompt
          source ${pkgs.nu_scripts}/share/nu_scripts/modules/prompt/oh-my.nu
          source ${../../../files/scripts/prompt.nu}
          source ${../../../files/scripts/skim.nu}
        '';
      };
    };
}
