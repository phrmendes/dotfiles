_: {
  modules.homeManager.dev.tmux =
    { pkgs, lib, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 0;
        keyMode = "vi";
        mouse = true;
        prefix = "C-space";
        shell = lib.getExe pkgs.zsh;
        extraConfig = ''
          set -g default-terminal "tmux-256color"
          set -g extended-keys on
          set -g extended-keys-format csi-u
          set -g allow-passthrough on
          set -g focus-events on
          set -g set-clipboard off
          set -g status-position top
          set -g status-left " #S "
          set -g status-right ""

          bind '-' split-window -v -c "#{pane_current_path}"
          bind '\' split-window -h -c "#{pane_current_path}"
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R
          bind q kill-pane
          bind d detach-client
        '';
      };
    };
}
