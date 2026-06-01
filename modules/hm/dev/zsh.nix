{ config, ... }:
{
  modules.homeManager.dev.zsh =
    { pkgs, lib, ... }:
    {
      home.sessionPath = [ "$HOME/.local/bin" ];

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
          g = lib.getExe pkgs.git;
          ld = lib.getExe pkgs.lazydocker;
          lg = lib.getExe pkgs.lazygit;
          v = "nvim";
          vr = "nvim-remote";
          vs = "nvim-server";
          s = "kitten ssh";
        };
        initContent = ''
          set -o vi

          _just_completion() { source <(JUST_COMPLETE=zsh ${pkgs.just}/bin/just) }
          compdef _just_completion just

          eval "$(${lib.getExe pkgs.devenv} hook zsh)"
        '';
      };
    };
}
