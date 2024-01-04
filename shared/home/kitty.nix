{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  font_family = "FiraCode Nerd Font Mono";
  font_size =
    if isDarwin
    then 16
    else 12;
in {
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "${font_family} Light";
      package = pkgs.fira-code-nerdfont;
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    settings = {
      allow_remote_control = "yes";
      bell_on_tab = false;
      bold_font = "${font_family} SemBd";
      bold_italic_font = "${font_family} SemBd Italic";
      enable_audio_bell = false;
      font_size = font_size;
      italic_font = "${font_family} Italic";
      listen_on = "unix:/tmp/mykitty";
      open_url_with = "default";
      scrollback_lines = 10000;
      term = "xterm-256color";
      undercurl_style = "thin-sparse";
      update_check_interval = 0;
      window_padding_width = 4;
      enabled_layouts = "splits:split_axis=horizontal,stack";
    };
    keybindings = {
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+shift+-" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
      "ctrl+h" = "kitten pass_keys.py left ctrl+h";
      "ctrl+j" = "kitten pass_keys.py bottom ctrl+j";
      "ctrl+k" = "kitten pass_keys.py top ctrl+k";
      "ctrl+l" = "kitten pass_keys.py right ctrl+l";
      "ctrl+shift+r" = "start_resizing_window";
      "ctrl+shift+up" = "move_window up";
      "ctrl+shift+down" = "move_window down";
      "ctrl+shift+left" = "move_window left";
      "ctrl+shift+right" = "move_window right";
      "ctrl+shift+enter" = "new_os_window";
      "ctrl+shift+q" = "close_os_window";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+j" = "next_window";
      "ctrl+shift+k" = "previous_window";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+d" = "close_tab";
      "ctrl+shift+m" = "layout_action rotate";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+x" = "close_window";
      "ctrl+shift+z" = "toggle_layout stack";
    };
  };
}
