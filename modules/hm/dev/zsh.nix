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
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
          {
            name = "zsh-nix-shell";
            src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
          }
        ];
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          cat = lib.getExe pkgs.bat;
          v = "nvim";
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
