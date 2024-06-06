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
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
        term = "screen-256color";
      };
      keybindings = {
        "alt+enter" = "layout_action rotate";
        "alt+minus" = "launch --location=hsplit --cwd=current";
        "alt+\\" = "launch --location=vsplit --cwd=current";
        "alt+q" = "close_tab";
        "alt+r" = "start_resizing_window";
        "alt+x" = "close_window";
        "alt+z" = "toggle_layout stack";
        "alt+t" = "new_tab";
        "alt+[" = "previous_tab";
        "alt+]" = "next_tab";
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";
        "alt+shift+t" = ''set_tab_title " "'';
        "alt+shift+equal" = "change_font_size all +2.0";
        "alt+shift+minus" = "change_font_size all -2.0";
      };
    };
  };
}
