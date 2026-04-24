{ config, ... }:
{
  modules.homeManager.dev.zsh =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autosuggestion.enable = true;
        history.path = "${config.settings.home}/.local/share/zsh/history";
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "zsh-fzf-tab";
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
            src = pkgs.zsh-fzf-tab;
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = pkgs.zsh-nix-shell;
          }
        ];
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          cat = lib.getExe pkgs.bat;
          fs = lib.getExe pkgs.fselect;
          g = lib.getExe pkgs.git;
          ld = lib.getExe pkgs.lazydocker;
          lg = lib.getExe pkgs.lazygit;
          v = "nvim";
        };
        initContent = ''
          export PATH="$HOME/.local/bin:$PATH"

          if [ -z "$DOCKER_HOST" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
            export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
          fi

          set -o vi

          source <(${pkgs.just}/bin/just --completions zsh)
        '';
      };
    };
}
