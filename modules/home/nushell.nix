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
          EDITOR = "nvim";
          DOCKER_HOST = lib.hm.nushell.mkNushellInline ''
            $"unix://($env.XDG_RUNTIME_DIR)/podman/podman.sock"
          '';
          GIT_EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
          PROMPT_INDICATOR = lib.hm.nushell.mkNushellInline "{|| \"\"}";
          PROMPT_INDICATOR_VI_INSERT = lib.hm.nushell.mkNushellInline "{|| \"\"}";
          PROMPT_INDICATOR_VI_NORMAL = lib.hm.nushell.mkNushellInline "{|| \"\"}";
        };
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          cat = lib.getExe pkgs.bat;
          k = lib.getExe pkgs.kubectl;
          open-secret = "agenix -i ~/.ssh/age -e";
          v = "nvim";
        };
      };
    };
}
