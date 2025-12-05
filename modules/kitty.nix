{
  lib,
  config,
  parameters,
  pkgs,
  ...
}:
{
  options.kitty.enable = lib.mkEnableOption "enable kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      shellIntegration.enableFishIntegration = true;
      settings = {
        active_tab_font_style = "bold";
        allow_remote_control = "yes";
        bell_on_tab = "  ";
        clear_all_shortcuts = "yes";
        enable_audio_bell = "no";
        enabled_layouts = "splits:split_axis=horizontal,stack";
        forward_remote_control = "yes";
        hide_window_decorations = "yes";
        inactive_text_alpha = "0.9";
        listen_on = "unix:/tmp/kitty";
        macos_option_as_alt = "yes";
        open_url_with = "default";
        shell = "fish";
        shell_integration = "enabled";
        tab_bar_edge = "bottom";
        tab_bar_min_tabs = 1;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index}:{title.split('/')[-1].split(':')[-1]}{'  ' if layout_name == 'stack' else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
      };
      extraConfig = ''
        action_alias relative_resize kitten ${parameters.home}/.config/kitty/relative_resize.py
        action_alias kitty_scrollback_nvim kitten ${parameters.home}/.config/kitty/scrollback.py

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
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+shift+," = "move_tab_backward";
        "ctrl+shift+." = "move_tab_forward";
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+enter" = "start_resizing_window";
        "ctrl+shift+f1" = "debug_config";
        "ctrl+shift+b" = "scroll_page_down";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+d" = "scroll_line_down";
        "ctrl+shift+f" = "scroll_page_up";
        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+j" = "move_window down";
        "ctrl+shift+k" = "move_window up";
        "ctrl+shift+l" = "move_window right";
        "ctrl+shift+n" = "new_tab_with_cwd";
        "ctrl+shift+o" = "open_url_with_hints";
        "ctrl+shift+q" = "close_window";
        "ctrl+shift+r" = "set_tab_title";
        "ctrl+shift+s" = "kitty_scrollback_nvim";
        "ctrl+shift+u" = "scroll_line_up";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+z" = "combine : toggle_layout stack : scroll_prompt_to_bottom";
        "ctrl+shift+1" = "goto_tab 1";
        "ctrl+shift+2" = "goto_tab 2";
        "ctrl+shift+3" = "goto_tab 3";
        "ctrl+shift+4" = "goto_tab 4";
        "ctrl+shift+5" = "goto_tab 5";
        "ctrl+shift+6" = "goto_tab 6";
        "ctrl+shift+7" = "goto_tab 7";
        "ctrl+shift+8" = "goto_tab 8";
        "ctrl+shift+9" = "goto_tab 9";
        "alt+h" = "relative_resize left 3";
        "alt+j" = "relative_resize down 3";
        "alt+k" = "relative_resize up 3";
        "alt+l" = "relative_resize right 3";
        "ctrl+h" = "neighboring_window left";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+l" = "neighboring_window right";
        "ctrl+minus" = "decrease_font_size";
        "ctrl+equal" = "increase_font_size";
        "ctrl+delete" = "change_font_size all 0";
      };
    };

    xdg.configFile = with pkgs.vimPlugins; {
      "kitty/neighboring_window.py".source = smart-splits-nvim + "/kitty/neighboring_window.py";
      "kitty/relative_resize.py".source = smart-splits-nvim + "/kitty/relative_resize.py";
      "kitty/scrollback.py".source = kitty-scrollback-nvim + "/python/kitty_scrollback_nvim.py";
    };
  };
}
