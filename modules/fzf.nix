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
      fd = lib.getExe pkgs.fd;
    in {
      enable = true;
      defaultCommand = "${fd} --type f";
      enableZshIntegration = true;
      changeDirWidgetCommand = "${fd} --type d";
      fileWidgetCommand = "${fd} --type f";
      tmux.enableShellIntegration = true;
      colors = with colors.catppuccin.palette; {
        "bg+" = "#${surface0}";
        "bg" = "#${base}";
        "spinner" = "#${rosewater}";
        "hl" = "#${red}";
        "fg" = "#${text}";
        "header" = "#${red}";
        "info" = "#${lavender}";
        "pointer" = "#${rosewater}";
        "marker" = "#${rosewater}";
        "fg+" = "#${text}";
        "prompt" = "#${lavender}";
        "hl+" = "#${red}";
      };
    };
  };
}
