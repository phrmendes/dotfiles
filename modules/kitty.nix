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
      };
      keybindings = {
        "alt+[" = "previous_tab";
        "alt+]" = "next_tab";
        "alt+\\" = "launch --location=vsplit --cwd=current";
        "alt+_" = "decrease_font_size";
        "alt+minus" = "launch --location=hsplit --cwd=current";
        "alt+plus" = "increase_font_size";
        "alt+enter" = "start_resizing_window";
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";
        "alt+n" = "new_tab";
        "alt+q" = "close_window";
        "alt+r" = "layout_action rotate";
        "alt+z" = "toggle_layout stack";
        "ctrl+h" = "no_op";
        "ctrl+j" = "no_op";
        "ctrl+k" = "no_op";
        "ctrl+l" = "no_op";
        "ctrl+left" = "no_op";
        "ctrl+down" = "no_op";
        "ctrl+up" = "no_op";
        "ctrl+right" = "no_op";
        "ctrl+shift+h" = "no_op";
        "ctrl+shift+j" = "no_op";
        "ctrl+shift+k" = "no_op";
        "ctrl+shift+l" = "no_op";
        "ctrl+shift+left" = "no_op";
        "ctrl+shift+down" = "no_op";
        "ctrl+shift+up" = "no_op";
        "ctrl+shift+right" = "no_op";
      };
    };
  };
}
