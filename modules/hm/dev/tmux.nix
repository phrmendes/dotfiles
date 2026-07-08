_: {
  modules.homeManager.dev.tmux =
    { pkgs, lib, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 0;
        mouse = true;
        prefix = "C-space";
        shell = lib.getExe pkgs.zsh;
        extraConfig = ''
          set -g  default-terminal     tmux-256color
          set -g  extended-keys        on
          set -g  extended-keys-format csi-u
          set -gq allow-passthrough    on
          set -g detach-on-destroy     off
          set -g focus-events          on
          set -g renumber-windows      on
          set -g set-clipboard         off
          set -g status                on
          set -g status-position       top
          set -g status-left           " #S "
          set -g status-right          ""

          set-window-option -g window-status-separator      ""
          set-window-option -g window-status-format         " #I:#W "
          set-window-option -g window-status-current-format "#[bold] #I:#W #[nobold]"

          bind '-'   split-window -v -c "#{pane_current_path}"
          bind ':'   command-prompt
          bind '\'   split-window -h -c "#{pane_current_path}"
          bind Enter rotate-window
          bind R     command-prompt -p "Name:" "new-session -s '%%'"
          bind d     detach-client
          bind h     select-pane -L
          bind j     select-pane -D
          bind k     kill-session
          bind k     select-pane -U
          bind l     select-pane -R
          bind n     new-window -c "#{pane_current_path}"
          bind q     kill-pane
          bind r     command-prompt -I "#W" "rename-window '%%'"
          bind w     choose-window
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
