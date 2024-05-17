{
  config,
  lib,
  pkgs,
  ...
}: {
  options.fzf.enable = lib.mkEnableOption "enable fzf";

  config = lib.mkIf config.fzf.enable {
    programs.fzf = let
      colors = import ./catppuccin.nix;
      bat = lib.getExe pkgs.bat;
      fd = lib.getExe pkgs.fd;
    in {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "${fd} --type f";
      changeDirWidgetCommand = "${fd} --type d";
      fileWidgetCommand = "${fd} --type f";
      fileWidgetOptions = [
        "--preview '${bat} --color=always {}'"
        "--preview-window '~3'"
      ];
      tmux.enableShellIntegration = true;
      colors = with colors.catppuccin.hex; {
        "bg+" = surface0;
        "bg" = base;
        "spinner" = rosewater;
        "hl" = red;
        "fg" = text;
        "header" = red;
        "info" = lavender;
        "pointer" = rosewater;
        "marker" = rosewater;
        "fg+" = text;
        "prompt" = lavender;
        "hl+" = red;
      };
    };
  };
}
