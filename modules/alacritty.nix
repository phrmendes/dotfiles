{
  config,
  lib,
  pkgs,
  ...
}: {
  options.alacritty.enable = lib.mkEnableOption "enable alacritty";

  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = let
      inherit (lib) getExe;
      tmux = getExe pkgs.tmux;
      zsh = getExe pkgs.zsh;
    in {
      enable = true;
      settings = {
        terminal.shell = {
          program = "${zsh}";
          args = [
            "-l"
            "-c"
            "${tmux} new-session -A -s default"
          ];
        };
        window = {
          dynamic_padding = true;
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };
  };
}
