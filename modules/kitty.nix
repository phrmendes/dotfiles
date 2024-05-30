{
  lib,
  config,
  ...
}: {
  options.kitty.enable = lib.mkEnableOption "enable kitty";

  config = lib.mkIf config.kitty.enable {
    xdg.configFile = {
      "kitty/neighboring_window.py".source = ../dotfiles/kitty/neighboring_window.py;
      "kitty/relative_resize.py".source = ../dotfiles/kitty/relative_resize.py;
    };

    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      settings = {
        allow_remote_control = "yes";
        bell_on_tab = "no";
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
        tab_title_template = "{title}{' #{}'.format(num_windows) if num_windows > 1 else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
      };
      keybindings = {
        "ctrl+equal" = "change_font_size all +2.0";
        "ctrl+minus" = "change_font_size all -2.0";
        "ctrl+shift+q" = "close_tab";
        "ctrl+shift+r" = "layout_action rotate";
        "ctrl+shift+x" = "close_window";
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+shift+enter" = ''set_tab_title " "'';
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
        "ctrl+h" = "neighboring_window left";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+l" = "neighboring_window right";
        "ctrl+shift+h" = "kitten relative_resize.py left 3";
        "ctrl+shift+j" = "kitten relative_resize.py down 3";
        "ctrl+shift+k" = "kitten relative_resize.py up 3";
        "ctrl+shift+l" = "kitten relative_resize.py right 3";
      };
      extraConfig = ''
        map --when-focus-on var:IS_NVIM ctrl+j
        map --when-focus-on var:IS_NVIM ctrl+k
        map --when-focus-on var:IS_NVIM ctrl+h
        map --when-focus-on var:IS_NVIM ctrl+l
        map --when-focus-on var:IS_NVIM ctrl+shift+j
        map --when-focus-on var:IS_NVIM ctrl+shift+k
        map --when-focus-on var:IS_NVIM ctrl+shift+h
        map --when-focus-on var:IS_NVIM ctrl+shift+l
      '';
    };
  };
}
