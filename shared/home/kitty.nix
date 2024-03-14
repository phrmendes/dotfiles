{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  font_family = "FiraCode Nerd Font Mono";
  font_size =
    if isDarwin
    then 16
    else 13;
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
      inherit font_size;
      allow_remote_control = "yes";
      bell_on_tab = false;
      bold_font = "${font_family} SemBd";
      bold_italic_font = "${font_family} SemBd Italic";
      enable_audio_bell = false;
      enabled_layouts = "splits:split_axis=horizontal,stack";
      italic_font = "${font_family} Italic";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "left";
      open_url_with = "default";
      scrollback_lines = 10000;
      shell_integration = "enabled";
      tab_bar_edge = "bottom";
      tab_bar_min_tabs = 2;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' #{}'.format(num_windows) if num_windows > 1 else ''}";
      term = "xterm-256color";
      undercurl_style = "thin-sparse";
      update_check_interval = 0;
      window_padding_width = 4;
    };
    keybindings = {
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+shift+-" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
      "ctrl+shift+r" = "start_resizing_window";
      "ctrl+shift+up" = "move_window up";
      "ctrl+shift+down" = "move_window down";
      "ctrl+shift+left" = "move_window left";
      "ctrl+shift+right" = "move_window right";
      "ctrl+shift+enter" = "new_os_window";
      "ctrl+shift+q" = "close_os_window";
      "ctrl+shift+n" = "next_window";
      "ctrl+shift+p" = "previous_window";
      "ctrl+shift+[" = "previous_tab";
      "ctrl+shift+]" = "next_tab";
      "ctrl+shift+d" = "close_tab";
      "ctrl+shift+m" = "layout_action rotate";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+x" = "close_window";
      "ctrl+shift+z" = "toggle_layout stack";
      "ctrl+shift+s" = "show_scrollback";
      "ctrl+shift+g" = "show_last_command_output";
      "ctrl+shift+h" = "no_op";
      "ctrl+shift+j" = "no_op";
      "ctrl+shift+k" = "no_op";
      "ctrl+shift+l" = "no_op";
    };
  };
}
