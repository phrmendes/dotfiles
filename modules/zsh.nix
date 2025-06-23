{
  lib,
  config,
  pkgs,
  parameters,
  ...
}:
{
  options.zsh.enable = lib.mkEnableOption "enable zsh";

  config = lib.mkIf config.zsh.enable {
    programs.zsh =
      let
        inherit (lib) getExe;
      in
      {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autosuggestion.enable = true;
        history.path = "${parameters.home}/.config/.zsh_history";
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
          apply = "git add . && nh os switch";
          asr = "${getExe pkgs.atuin} scripts run";
          cat = getExe pkgs.bat;
          du = getExe pkgs.gdu;
          find = getExe pkgs.fd;
          fs = getExe pkgs.fselect;
          g = getExe pkgs.git;
          grep = getExe pkgs.ripgrep;
          k = "${pkgs.kubectl}/bin/kubectl";
          ld = getExe pkgs.lazydocker;
          lg = getExe pkgs.lazygit;
          ps = getExe pkgs.procs;
          sed = getExe pkgs.gnused;
          src = "source .venv/bin/activate";
          t = "${getExe pkgs.tmux} new-session -A -s default";
          top = getExe pkgs.btop;
          v = "nvim";
        };
        initContent = ''
          export PATH="$HOME/.local/bin:$PATH"
          export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
          export PATH="/run/current-system/sw/bin:$PATH"
          export PATH="/run/wrappers/bin:$PATH"

          set -o vi

          eval "$(${getExe pkgs.just} --completions zsh)"
          eval "$(${getExe pkgs.uv} generate-shell-completion zsh)"
          eval "$(${getExe pkgs.kubernetes-helm} completion zsh)"

          function diff_persist() {
            sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
          }
        '';
      };
  };
}
