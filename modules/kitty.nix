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
        hide_window_decorations = "yes";
      };
      keybindings = {
        "ctrl+equal" = "increase_font_size";
        "ctrl+minus" = "decrease_font_size";
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+enter" = "start_resizing_window";
        "ctrl+shift+n" = "new_tab";
        "ctrl+shift+q" = "close_window";
        "ctrl+shift+r" = "layout_action rotate";
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+shift+h" = "neighboring_window left";
        "ctrl+shift+j" = "neighboring_window down";
        "ctrl+shift+k" = "neighboring_window up";
        "ctrl+shift+l" = "neighboring_window right";
        "alt+h" = "no_op";
        "alt+j" = "no_op";
        "alt+k" = "no_op";
        "alt+l" = "no_op";
        "ctrl+h" = "no_op";
        "ctrl+j" = "no_op";
        "ctrl+k" = "no_op";
        "ctrl+l" = "no_op";
      };
    };
  };
}
