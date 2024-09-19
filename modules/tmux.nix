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
      tmuxp.enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      historyLimit = 1000000;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      shell = lib.getExe pkgs.zsh;
      terminal = "xterm-256color";
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
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-restore               'r'
            set -g @resurrect-save                  's'
            set -g @resurrect-strategy-nvim         'session'
          '';
        }
        {
          plugin = fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-bind 'o'
          '';
        }
      ];
      extraConfig = let
        status_bar = "[  #I   #W#{?window_zoomed_flag,  ,}#{?window_bell_flag,  ,} ]";
      in ''
        unbind ','

        set -g detach-on-destroy   'off'
        set -g renumber-windows    'on'
        set -g set-clipboard       'on'
        set -g status              'on'
        set -g status-interval     3
        set -g status-justify      'left'
        set -g status-left         ""
        set -g status-left-length  '80'
        set -g status-left-style   none
        set -g status-position     top
        set -g status-right        '[  #S ]'
        set -g status-right-length '80'
        set -g status-right-style  none
        set -g visual-activity     'off'
        set -ga terminal-overrides ',xterm-256color:RGB'
        set -gq allow-passthrough  'on'

        set-window-option -g visual-bell                  'on'
        set-window-option -g bell-action                  'other'
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

        bind -r ',' swap-pane -U
        bind -r '.' swap-pane -D
        bind -r '<' previous-layout
        bind -r '>' next-layout
        bind -r '[' previous-window
        bind -r ']' next-window
        bind -r '{' swap-window -t -1\; select-window -t -1
        bind -r '}' swap-window -t +1\; select-window -t +1

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
      '';
    };
  };
}
