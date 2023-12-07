{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
      tmux-fzf
      {
        plugin = tmux-fzf;
        extraConfig = ''
          TMUX_FZF_LAUNCH_KEY="C-Space"
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_status_left_separator "█"
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];
    extraConfig = ''
      set -ag terminal-overrides ',xterm-256color:RGB'
      set -g status-position top

      unbind '"'
      unbind %

      bind '-' split-window -v -c '#{pane_current_path}'
      bind '\' split-window -h -c '#{pane_current_path}'
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
