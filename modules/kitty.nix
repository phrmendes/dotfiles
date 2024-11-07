{
  lib,
  config,
  ...
}: {
  options.kitty.enable = lib.mkEnableOption "enable kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      settings = {
        allow_remote_control = "yes";
        clear_all_shortcuts = "yes";
        enable_audio_bell = "no";
        enabled_layouts = "splits:split_axis=horizontal,stack";
        forward_remote_control = "yes";
        inactive_text_alpha = "0.9";
        listen_on = "unix:/tmp/kitty";
        macos_option_as_alt = "yes";
        open_url_with = "default";
        scrollback_lines = 5000;
        shell_integration = "enabled";
        tab_bar_edge = "bottom";
        tab_bar_min_tabs = 2;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index}: {title.split('/')[-1].split(':')[-1]}{' (Z)' if layout_name == 'stack' else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
      };
      keybindings = {
        "alt+enter" = "layout_action rotate";
        "alt+minus" = "launch --location=hsplit --cwd=current";
        "alt+\\" = "launch --location=vsplit --cwd=current";
        "alt+[" = "previous_tab";
        "alt+]" = "next_tab";
        "alt+_" = "decrease_font_size";
        "alt+plus" = "increase_font_size";
        "alt+u" = "scroll_line_up";
        "alt+d" = "scroll_line_down";
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";
        "alt+n" = "new_tab_with_cwd";
        "alt+q" = "close_window";
        "alt+r" = "set_tab_title";
        "alt+s" = "show_scrollback";
        "alt+t" = "select_tab";
        "alt+z" = "combine : toggle_layout stack : scroll_prompt_to_bottom";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "alt+left" = "kitten relative_resize.py left 3";
        "alt+down" = "kitten relative_resize.py down 3";
        "alt+up" = "kitten relative_resize.py up 3";
        "alt+right" = "kitten relative_resize.py right 3";
        "alt+shift+n" = "new_window";
        "alt+shift+d" = "scroll_page_down";
        "alt+shift+u" = "scroll_page_up";
        "alt+shift+left" = "move_window left";
        "alt+shift+down" = "move_window down";
        "alt+shift+up" = "move_window up";
        "alt+shift+right" = "move_window right";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
      };
    };

    xdg.configFile = {
      "kitty/relative_resize.py".source = ../dotfiles/kitty/relative_resize.py;
      "kitty/open-actions.conf".source = ../dotfiles/kitty/open-actions.conf;
    };
  };
}
