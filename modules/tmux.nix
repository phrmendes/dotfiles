{
  config,
  lib,
  pkgs,
  parameters,
  ...
}: {
  options.tmux.enable = lib.mkEnableOption "enable tmux";

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      tmuxp.enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      prefix = "C-Space";
      shell = lib.getExe pkgs.zsh;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY='C-Space'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-boot          'on'
            set -g @continuum-restore       'on'
            set -g @continuum-save-interval '5'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = let
            resurrect_dir = "${parameters.home}/.tmux/resurrect";
          in ''
            set -g @resurrect-dir                   '${resurrect_dir}'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-restore               'C-r'
            set -g @resurrect-save                  'C-s'
            set -g @resurrect-strategy-nvim         'session'
            set -g @resurrect-processes             'nvim "~nvim->nvim"'
          '';
        }
      ];
      extraConfig = let
        status_bar = "  #I: #W#{?window_zoomed_flag, ,}#{?window_bell_flag, ,} ";
      in ''
        set -g default-terminal    "alacritty"
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # colored underscores
        set -as terminal-overrides ',alacritty:RGB'                                                                # true-color support

        unbind ','

        set -g detach-on-destroy   'off'
        set -g display-time        4000
        set -g focus-events        'on'
        set -g renumber-windows    'on'
        set -g set-clipboard       'on'
        set -g status              'on'
        set -g status-interval     3
        set -g status-justify      'left'
        set -g status-left         ""
        set -g status-left-length  '80'
        set -g status-left-style   none
        set -g status-position     top
        set -g status-right        '  #S '
        set -g status-right-length '80'
        set -g status-right-style  none
        set -g visual-activity     'off'
        set -gq allow-passthrough  'on'

        set-window-option -g visual-bell                  'on'
        set-window-option -g bell-action                  'other'
        set-window-option -g window-status-separator      ''
        set-window-option -g window-status-format         '${status_bar}'
        set-window-option -g window-status-current-format '#[bold]${status_bar}#[nobold]'

        bind Enter rotate-window
        bind ':'   command-prompt
        bind '-'   split-window -v -c '#{pane_current_path}'
        bind '\'   split-window -h -c '#{pane_current_path}'
        bind G     last-window
        bind Q     kill-window
        bind d     detach-client
        bind k     kill-session
        bind n     new-window
        bind p     paste-buffer
        bind q     kill-pane
        bind r     command-prompt -I "#W" "rename-window '%%'"
        bind y     copy-mode
        bind z     resize-pane -Z
        bind m     set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"

        bind -r ',' swap-pane -U
        bind -r '.' swap-pane -D
        bind -r '<' previous-layout
        bind -r '>' next-layout
        bind -r '[' previous-window
        bind -r ']' next-window
        bind -r '{' swap-window -t -1\; select-window -t -1
        bind -r '}' swap-window -t +1\; select-window -t +1
        bind -r ')' switch-client -n
        bind -r '(' switch-client -p

        bind -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
        bind -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
        bind -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
        bind -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'

        bind -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
        bind -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
        bind -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
        bind -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

        bind -T copy-mode-vi C-h select-pane -L
        bind -T copy-mode-vi C-j select-pane -D
        bind -T copy-mode-vi C-k select-pane -U
        bind -T copy-mode-vi C-l select-pane -R
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind -T copy-mode-vi v   send-keys -X begin-selection
        bind -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

        run-shell "tmux has-session -t 0 2>/dev/null && tmux kill-session -t 0"
      '';
    };
  };
}
