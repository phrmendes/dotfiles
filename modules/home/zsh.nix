{ config, ... }:
{
  homeModules.zsh =
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
          {
            name = "zsh-vi-mode";
            src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
          }
        ];
        shellAliases = {
          asr = "${lib.getExe pkgs.atuin} scripts run";
          cat = lib.getExe pkgs.bat;
          open-secret = "agenix -i ~/.ssh/age -e";
          v = "nvim";
        };
      };
    };
}
