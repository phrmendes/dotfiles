{
  homeModules.nushell =
    { lib, pkgs, ... }:
    {
      home.sessionPath = [ "$HOME/.local/bin" ];

      programs.nushell = {
        enable = true;
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
          PI_NUSHELL_PATH = "${pkgs.nushell}/bin/nu";
          PI_SKIP_VERSION_CHECK = "1";
          PROMPT_INDICATOR = lib.hm.nushell.mkNushellInline ''{|| ""}'';
          PROMPT_INDICATOR_VI_INSERT = lib.hm.nushell.mkNushellInline ''{|| ""}'';
          PROMPT_INDICATOR_VI_NORMAL = lib.hm.nushell.mkNushellInline ''{|| $"(ansi purple)[N](ansi reset) "}'';
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
        };
        plugins = with pkgs.nushellPlugins; [ polars ];
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          authelia-secret = "${lib.getExe pkgs.authelia} crypto hash generate argon2 --password";
          cat = lib.getExe pkgs.bat;
          k = lib.getExe pkgs.kubectl;
          open-secret = "${lib.getExe pkgs.agenix-cli} -i ~/.ssh/age -e";
          v = "nvim";
        };
      };
    };
}
