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
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    tmuxp.enable = true;
    historyLimit = 1000000;
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      tmux-thumbs
      vim-tmux-navigator
      yank
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key 'C-f'
        '';
      }
      {
        plugin = tmux-fzf;
        extraConfig = ''
          TMUX_FZF_LAUNCH_KEY='C-Space'
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_status_left_separator '█'
          set -g @catppuccin_window_current_text '#W#{?window_zoomed_flag, (),}'
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
      set-option -g terminal-overrides ',xterm-256color:RGB'

      set -g detach-on-destroy off
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'
      set -g renumber-windows on
      set -g set-clipboard on
      set -g status-position top

      setw -g mode-keys vi

      unbind '"'
      unbind %

      bind '-' split-window -v -c '#{pane_current_path}'
      bind '\' split-window -h -c '#{pane_current_path}'
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      bind -r m resize-pane -Z

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
