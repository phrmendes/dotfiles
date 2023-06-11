{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    sensibleOnTop = true;
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      continuum
      resurrect
      vim-tmux-navigator
      yank
    ];
    extraConfig = builtins.readFile ../cfg/tmux.conf;
  };
}
