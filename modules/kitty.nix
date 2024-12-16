{
  lib,
  config,
  parameters,
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
        tab_title_template = " {index}: {title.split('/')[-1].split(':')[-1]}{'  ' if layout_name == 'stack' else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
        bell_on_tab = "  ";
      };
      extraConfig = ''
        action_alias kitty_scrollback_nvim kitten ${parameters.home}/.config/kitty/python/kitty_scrollback_nvim.py
        action_alias relative_resize kitten ${parameters.home}/.config/kitty/relative_resize.py

        map --when-focus-on var:IS_NVIM alt+h
        map --when-focus-on var:IS_NVIM alt+j
        map --when-focus-on var:IS_NVIM alt+k
        map --when-focus-on var:IS_NVIM alt+l

        map --when-focus-on var:IS_NVIM ctrl+h
        map --when-focus-on var:IS_NVIM ctrl+j
        map --when-focus-on var:IS_NVIM ctrl+k
        map --when-focus-on var:IS_NVIM ctrl+l
      '';
      keybindings = {
        "ctrl+space>\\" = "launch --location=vsplit --cwd=current";
        "ctrl+space>minus" = "launch --location=hsplit --cwd=current";
        "ctrl+space>[" = "previous_tab";
        "ctrl+space>]" = "next_tab";
        "ctrl+space>f" = "kitty_scrollback_nvim";
        "ctrl+space>h" = "move_window left";
        "ctrl+space>j" = "move_window down";
        "ctrl+space>k" = "move_window up";
        "ctrl+space>l" = "move_window right";
        "ctrl+space>n" = "new_tab_with_cwd";
        "ctrl+space>o" = "open_url_with_hints";
        "ctrl+space>q" = "close_window";
        "ctrl+space>r" = "set_tab_title";
        "ctrl+space>z" = "combine : toggle_layout stack : scroll_prompt_to_bottom";
        "ctrl+space>1" = "goto_tab 1";
        "ctrl+space>2" = "goto_tab 2";
        "ctrl+space>3" = "goto_tab 3";
        "ctrl+space>4" = "goto_tab 4";
        "ctrl+space>5" = "goto_tab 5";
        "ctrl+space>6" = "goto_tab 6";
        "ctrl+space>7" = "goto_tab 7";
        "ctrl+space>8" = "goto_tab 8";
        "ctrl+space>9" = "goto_tab 9";
        "alt+h" = "relative_resize left 3";
        "alt+j" = "relative_resize down 3";
        "alt+k" = "relative_resize up 3";
        "alt+l" = "relative_resize right 3";
        "ctrl+h" = "neighboring_window left";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+l" = "neighboring_window right";
        "ctrl+shift+u" = "scroll_line_up";
        "ctrl+shift+d" = "scroll_line_down";
        "ctrl+shift+f" = "scroll_page_up";
        "ctrl+shift+b" = "scroll_page_down";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+minus" = "decrease_font_size";
        "ctrl+shift+equal" = "increase_font_size";
        "ctrl+shift+backspace" = "change_font_size all 0";
        "ctrl+shift+f1" = "debug_config";
      };
    };

    xdg.configFile = {
      "kitty/open-actions.conf".source = ../dotfiles/kitty/open-actions.conf;
      "kitty/neighboring_window.py".source = ../dotfiles/kitty/python/neighboring_window.py;
      "kitty/relative_resize.py".source = ../dotfiles/kitty/python/relative_resize.py;
      "kitty/python/kitty_scroll_prompt.py".source = ../dotfiles/kitty/python/kitty_scroll_prompt.py;
      "kitty/python/kitty_scrollback_nvim.py".source = ../dotfiles/kitty/python/kitty_scrollback_nvim.py;
      "kitty/python/loading.py".source = ../dotfiles/kitty/python/loading.py;
    };
  };
}
