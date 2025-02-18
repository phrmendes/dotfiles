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
        shellAliases =
          let
            kitten = "${pkgs.kitty}/bin/kitten";
          in
          {
            cat = getExe pkgs.bat;
            du = getExe pkgs.gdu;
            find = getExe pkgs.fd;
            fs = getExe pkgs.fselect;
            g = getExe pkgs.git;
            grep = getExe pkgs.ripgrep;
            hg = "${kitten} hyperlinked-grep";
            k = "${pkgs.kubectl}/bin/kubectl";
            ld = getExe pkgs.lazydocker;
            lg = getExe pkgs.lazygit;
            ps = getExe pkgs.procs;
            s = "${kitten} ssh";
            sed = getExe pkgs.gnused;
            top = getExe pkgs.btop;
            transfer = "${kitten} transfer";
            v = "nvim";
            zz = ''${getExe pkgs.zellij} attach --create "$(basename $PWD)"'';
          };
        initExtra = ''
          export EDITOR="nvim"
          export GIT_EDITOR="nvim"
          export SUDO_EDITOR="nvim"
          export VISUAL="nvim"

          export PATH="$HOME/.local/bin:$PATH"
          export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
          export PATH="/run/current-system/sw/bin:$PATH"
          export PATH="/run/wrappers/bin:$PATH"

          set -o vi

          function diff_persist() {
              sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
          }

          eval "$(${getExe pkgs.just} --completions zsh)"
          eval "$(${getExe pkgs.uv} generate-shell-completion zsh)"
        '';
      };
  };
}
