{
  lib,
  config,
  ...
}:
{
  options.ghostty.enable = lib.mkEnableOption "enable ghostty";

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      clearDefaultKeybinds = true;
      settings = {
        window-padding-x = 5;
        window-padding-y = 5;
        keybind = [
          "ctrl+shift+minus=new_split:down"
          "ctrl+shift+\\=new_split:right"
          "ctrl+shift+tab=toggle_tab_overview"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:bottom"
          "ctrl+shift+k=goto_split:top"
          "ctrl+shift+l=goto_split:right"
          "ctrl+shift+n=new_tab"
          "ctrl+shift+q=close_surface"
          "ctrl+shift+s=write_scrollback_file:open"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+z=toggle_split_zoom"
          "ctrl+shift+up=resize_split:up,10"
          "ctrl+shift+down=resize_split:down,10"
          "ctrl+shift+left=resize_split:left,10"
          "ctrl+shift+right=resize_split:right,10"
          "ctrl+shift+0=equalize_splits"
          "ctrl+shift+[=previous_tab"
          "ctrl+shift+]=next_tab"
          "ctrl+shift+1=goto_tab:1"
          "ctrl+shift+2=goto_tab:2"
          "ctrl+shift+3=goto_tab:3"
          "ctrl+shift+4=goto_tab:4"
          "ctrl+shift+5=goto_tab:5"
          "ctrl+shift+6=goto_tab:6"
          "ctrl+shift+7=goto_tab:7"
          "ctrl+shift+8=goto_tab:8"
          "ctrl+shift+9=goto_tab:9"
          "ctrl+0=reset_font_size"
          "ctrl+equal=increase_font_size:1"
          "ctrl+minus=decrease_font_size:1"
        ];
      };
    };
  };
}
