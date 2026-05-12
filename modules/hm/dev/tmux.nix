_: {
  modules.homeManager.dev.tmux =
    { pkgs, lib, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        newSession = true;
        prefix = "C-space";
        shell = lib.getExe pkgs.zsh;
        extraConfig = ''
          set -g  default-terminal   tmux-256color
          set -g  extended-keys        on
          set -g  extended-keys-format csi-u
          set -ag terminal-overrides ",xterm-256color:RGB"
          set -ag terminal-overrides ",xterm-kitty:RGB"
          set -gq allow-passthrough  on
          set -g detach-on-destroy   off
          set -g focus-events        on
          set -g renumber-windows    on
          set -g set-clipboard       on
          set -g status          on
          set -g status-position top
          set -g status-left     " #S "
          set -g status-right    ""

          set-window-option -g window-status-separator      ""
          set-window-option -g window-status-format         " #I:#W "
          set-window-option -g window-status-current-format "#[bold] #I:#W #[nobold]"

          bind '-'   split-window -v -c "#{pane_current_path}"
          bind ':'   command-prompt
          bind '\'   split-window -h -c "#{pane_current_path}"
          bind Enter rotate-window
          bind d     detach-client
          bind k     kill-session
          bind n     new-window -c "#{pane_current_path}"
          bind q     kill-pane
          bind w     choose-window
          bind h     select-pane -L
          bind j     select-pane -D
          bind k     select-pane -U
          bind l     select-pane -R
          bind z     resize-pane -Z
          bind -r H  resize-pane -L 5
          bind -r J  resize-pane -D 5
          bind -r K  resize-pane -U 5
          bind -r L  resize-pane -R 5
          bind -r [  previous-window
          bind -r ]  next-window
        '';
      };
    };
}
