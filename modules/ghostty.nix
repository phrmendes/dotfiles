{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.ghostty.enable = lib.mkEnableOption "enable ghostty";

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      clearDefaultKeybinds = true;
      installBatSyntax = true;
      installVimSyntax = true;
      settings =
        let
          tmux = lib.getExe pkgs.tmux;
        in
        {
          clipboard-paste-protection = "true";
          clipboard-read = "allow";
          clipboard-trim-trailing-spaces = "true";
          clipboard-write = "allow";
          confirm-close-surface = false;
          window-padding-x = 5;
          window-padding-y = 5;
          window-save-state = "never";
          command = [ "${tmux} new-session -A -s default" ];
          keybind = [
            "ctrl+shift+a=select_all"
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+u=copy_url_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"
            "ctrl+minus=decrease_font_size:1"
            "ctrl+equal=increase_font_size:1"
            "ctrl+backspace=reset_font_size"
          ];
        };
    };
  };
}
