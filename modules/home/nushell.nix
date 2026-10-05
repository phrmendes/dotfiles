{ inputs, ... }:
{
  homeModules.nushell =
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
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          EDITOR = "nvim";
          GIT_EDITOR = "nvim";
          PI_CACHE_RETENTION = "long";
          PI_NUSHELL_PATH = "${pkgs.local.nushell}/bin/nu";
          PI_SKIP_VERSION_CHECK = "1";
          PROMPT_COMMAND_RIGHT = "";
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
          _ZO_MAXAGE = "100000";
        };
        shellAliases =
          let
            agenix = inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          {
            asr = "${lib.getExe pkgs.atuin} scripts run";
            cat = lib.getExe pkgs.bat;
            create-secret = "${lib.getExe pkgs.authelia} crypto hash generate argon2 --password";
            k = lib.getExe pkgs.kubectl;
            open-secret = "${lib.getExe' agenix "agenix"} -i ~/.ssh/age -e";
            v = "nvim";
          };
        extraConfig = ''
          use ${pkgs.nu_scripts}/share/nu_scripts/modules/prompt/basic-git.nu basic-git-left-prompt
          source ${pkgs.nu_scripts}/share/nu_scripts/modules/prompt/oh-my.nu
          source ${../../files/prompt.nu}
        '';
      };
    };
}
