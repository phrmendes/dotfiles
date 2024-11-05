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
        enable_audio_bell = "no";
        enabled_layouts = "splits:split_axis=horizontal,stack";
        inactive_text_alpha = "0.9";
        listen_on = "unix:/tmp/kitty";
        macos_option_as_alt = "yes";
        open_url_with = "default";
        scrollback_lines = 10000;
        shell_integration = "enabled";
        tab_bar_edge = "bottom";
        tab_bar_min_tabs = 2;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index}: {title}{' (Z)' if layout_name == 'stack' else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
      };
      keybindings = {
        "alt+[" = "previous_tab";
        "alt+]" = "next_tab";
        "alt+\\" = "launch --location=vsplit --cwd=current";
        "alt+_" = "decrease_font_size";
        "alt+minus" = "launch --location=hsplit --cwd=current";
        "alt+plus" = "increase_font_size";
        "alt+enter" = "layout_action rotate";
        "alt+n" = "new_tab_with_cwd";
        "alt+shift+n" = "new_window";
        "alt+q" = "close_window";
        "alt+r" = "set_tab_title";
        "alt+z" = "combine : toggle_layout stack : scroll_prompt_to_bottom";
        "alt+g" = "kitten kitty_scrollback.py --config ksb_builtin_last_cmd_output";
        "alt+s" = "kitten kitty_scrollback.py";
        "alt+h" = "kitten relative_resize.py left 3";
        "alt+j" = "kitten relative_resize.py down 3";
        "alt+k" = "kitten relative_resize.py up 3";
        "alt+l" = "kitten relative_resize.py right 3";
        "alt+t" = "select_tab";
        "alt+d" = "scroll_line_down";
        "alt+u" = "scroll_line_up";
        "alt+shift+d" = "scroll_page_down";
        "alt+shift+u" = "scroll_page_up";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "ctrl+h" = "neighboring_window left";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+l" = "neighboring_window right";
        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+l" = "move_window right";
        "ctrl+shift+k" = "move_window up";
        "ctrl+shift+j" = "move_window down";
        "f1" = "launch --allow-remote-control kitty +kitten broadcast --match-tab state:focused";
      };
      extraConfig = ''
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitten kitty_scrollback.py --config ksb_builtin_last_visited_cmd_output

        map --when-focus-on var:IS_NVIM ctrl+j
        map --when-focus-on var:IS_NVIM ctrl+k
        map --when-focus-on var:IS_NVIM ctrl+h
        map --when-focus-on var:IS_NVIM ctrl+l
        map --when-focus-on var:IS_NVIM alt+j
        map --when-focus-on var:IS_NVIM alt+k
        map --when-focus-on var:IS_NVIM alt+h
        map --when-focus-on var:IS_NVIM alt+l
      '';
    };

    xdg.configFile = {
      "kitty/neighboring_window.py".source = ../dotfiles/kitty/neighboring_window.py;
      "kitty/relative_resize.py".source = ../dotfiles/kitty/relative_resize.py;
      "kitty/split_window.py".source = ../dotfiles/kitty/split_window.py;
      "kitty/kitty_scrollback.py".source = ../dotfiles/kitty/kitty_scrollback.py;
      "kitty/open-actions.conf".source = ../dotfiles/kitty/open-actions.conf;
    };
  };
}
