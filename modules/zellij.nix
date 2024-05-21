{
  lib,
  config,
  pkgs,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        copy_clipboard = "primary";
        copy_on_select = true;
        default_shell = "${lib.getExe pkgs.zsh}";
        mouse_mode = true;
        pane_frames = false;
        simplified_ui = true;
        ui.pane_frames.hide_session_name = true;
      };
    };
  };
}
