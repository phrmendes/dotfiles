{
  config,
  lib,
  pkgs,
  ...
}: {
  options.alacritty.enable = lib.mkEnableOption "enable alacritty";

  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        terminal = let
          inherit (lib) getExe;
          tmux = getExe pkgs.tmux;
          zsh = getExe pkgs.zsh;
        in {
          shell = {
            program = "${zsh}";
            args = [
              "-l"
              "-c"
              "${tmux} new-session -A -s default"
            ];
          };
        };
        window = {
          dynamic_padding = false;
          padding = {
            x = 15;
            y = 10;
          };
        };
      };
    };
  };
}
