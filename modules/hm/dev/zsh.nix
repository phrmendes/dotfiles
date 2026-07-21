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
          v = "nvim";
          vr = "nvim-remote";
          vs = "nvim-server";
          s = "kitten ssh";
        };
        initContent = ''
          set -o vi

          deploy() {
            local target="''${1:?usage: deploy <target> [address]}"
            local address="''${2:-$target}"
            nixos-rebuild switch --flake ".#''${target}" --target-host "phrmendes@''${address}" --sudo
          }

          _just_completion() { source <(JUST_COMPLETE=zsh ${pkgs.just}/bin/just) }
          compdef _just_completion just

          [ -x "${lib.getExe pkgs.devenv}" ] && eval "$(${lib.getExe pkgs.devenv} hook zsh)"
        '';
      };
    };
}
