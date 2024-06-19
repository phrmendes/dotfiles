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
            TMUX_FZF_LAUNCH_KEY='Enter'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-boot 'on'
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-restore 'C-r'
            set -g @resurrect-save 'C-s'
          '';
        }
      ];
      extraConfig = let
        status_bar = "[  #I   #W#{?window_zoomed_flag,  ,}#{?window_bell_flag,  ,} ]";
      in ''
        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-interval 3
        set -g visual-activity off
        set -ga terminal-overrides ',xterm-256color:RGB'
        set -gq allow-passthrough on

        set -g status 'on'
        set -g status-justify 'left'
        set -g status-left ""
        set -g status-left-length '80'
        set -g status-left-style none
        set -g status-position top
        set -g status-right '[  #S ]'
        set -g status-right-length '80'
        set -g status-right-style none

        set-window-option -g visual-bell on
        set-window-option -g bell-action other
        set-window-option -g window-status-format '${status_bar}'
        set-window-option -g window-status-current-format '#[bold]${status_bar}#[nobold]'

        bind ':' command-prompt
        bind '-' split-window -v -c '#{pane_current_path}'
        bind '\' split-window -h -c '#{pane_current_path}'
        bind ']' next-window
        bind '[' previous-window
        bind '}' swap-pane -D
        bind '{' swap-pane -U
        bind G last-window
        bind P paste-buffer
        bind X kill-window
        bind d detach-client
        bind n new-window
        bind p paste-buffer
        bind q kill-session
        bind r rotate-window
        bind x kill-pane
        bind y copy-mode
        bind z resize-pane -Z

        bind -r Space next-layout

        bind -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
        bind -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
        bind -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
        bind -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

        bind -n C-Left if -F "#{@pane-is-vim}" 'send-keys C-Left' 'resize-pane -L 3'
        bind -n C-Down if -F "#{@pane-is-vim}" 'send-keys C-Down' 'resize-pane -D 3'
        bind -n C-Up if -F "#{@pane-is-vim}" 'send-keys C-Up' 'resize-pane -U 3'
        bind -n C-Right if -F "#{@pane-is-vim}" 'send-keys C-Right' 'resize-pane -R 3'

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
