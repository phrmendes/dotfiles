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
          AGENT_BROWSER_EXECUTABLE_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          DOCKER_HOST = lib.hm.nushell.mkNushellInline ''$"unix://($env.XDG_RUNTIME_DIR)/podman/podman.sock" '';
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
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          cat = lib.getExe pkgs.bat;
          create-secret = "${lib.getExe pkgs.authelia} crypto hash generate argon2 --password";
          k = lib.getExe pkgs.kubectl;
          open-secret = "${lib.getExe pkgs.agenix-cli} -i ~/.ssh/age -e";
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
