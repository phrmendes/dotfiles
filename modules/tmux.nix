{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tmux.enable = lib.mkEnableOption "enable tmux";

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      enable = true;
      escapeTime = 0;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      shell = lib.getExe pkgs.zsh;
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank-selection 'clipboard'
          '';
        }
        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY='C-Space'
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
      extraConfig = ''
        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g visual-activity off
        set -ga terminal-overrides ",screen-256color:Tc"
        set -gq allow-passthrough on

        set -g status "on"
        set -g status-position top
        set -g status-justify "left"
        set -g status-left-style none
        set -g status-left-length "80"
        set -g status-right-style none
        set -g status-right-length "80"

        set -g status-left " [󰖯 #I] [ #W]#{?window_zoomed_flag, [] ,} "
        set -g status-right " [ #S] "

        set-window-option -g window-status-current-format ""
        set-window-option -g window-status-format ""

        bind ':' command-prompt
        bind '-' split-window -v -c '#{pane_current_path}'
        bind '\' split-window -h -c '#{pane_current_path}'
        bind ']' next-window
        bind '[' previous-window
        bind '}' swap-pane -D
        bind '{' swap-pane -U
        bind G last-window
        bind P paste-buffer
        bind X confirm kill-window
        bind d detach-client
        bind q confirm kill-server
        bind n new-window
        bind x kill-pane
        bind y copy-mode
        bind p paste-buffer
        bind r rotate-window
        bind z resize-pane -Z

        bind -r h resize-pane -L 3
        bind -r j resize-pane -D 3
        bind -r k resize-pane -U 3
        bind -r l resize-pane -R 3

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
