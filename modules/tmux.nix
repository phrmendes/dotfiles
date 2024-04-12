{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tmux.enable = lib.mkEnableOption "enable tmux";

  config = lib.mkIf config.tmux.enable {
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
      shell = lib.getExe pkgs.zsh;
      terminal = "screen-256color";
      tmuxp.enable = true;
      historyLimit = 5000;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank-selection 'clipboard'
          '';
        }
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
            set -g @catppuccin_status_modules_right 'application session'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-save 's'
            set -g @resurrect-restore 'r'
          '';
        }
      ];
      extraConfig = ''
        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-position top
        set -g terminal-overrides ',xterm-256color:RGB'
        set -g visual-activity off
        set -gq allow-passthrough on
        setw -g mode-keys vi

        unbind '"'
        unbind %
        unbind &
        unbind [
        unbind y

        bind '-' split-window -v -c '#{pane_current_path}'
        bind '\' split-window -h -c '#{pane_current_path}'
        bind ']' next-window
        bind '[' previous-window
        bind D confirm kill-server
        bind G last-window
        bind P paste-buffer
        bind X confirm kill-window
        bind d detach-client
        bind w new-window
        bind x kill-pane
        bind y copy-mode
        bind z resize-pane -Z
        bind 1 select-window -t 1
        bind 2 select-window -t 2
        bind 3 select-window -t 3
        bind 4 select-window -t 4
        bind 5 select-window -t 5
        bind 6 select-window -t 6
        bind 7 select-window -t 7
        bind 8 select-window -t 8
        bind 9 select-window -t 9

        bind h swap-pane -L
        bind j swap-pane -D
        bind k swap-pane -U
        bind l swap-pane -R
        bind -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
        bind -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
        bind -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
        bind -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'
        bind -n C-Left if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
        bind -n C-Down if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
        bind -n C-Up if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
        bind -n C-Right if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

        bind -T copy-mode-vi 'C-h' select-pane -L
        bind -T copy-mode-vi 'C-j' select-pane -D
        bind -T copy-mode-vi 'C-k' select-pane -U
        bind -T copy-mode-vi 'C-l' select-pane -R
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      '';
    };
  };
}
