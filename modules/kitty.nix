{
  lib,
  config,
  pkgs,
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
      settings = let
        inherit (pkgs.stdenv) isLinux;
      in {
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
        window_padding_width = 6;
        term = "xterm-256color";
      };
      keybindings = {
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+enter" = "start_resizing_window";
        "ctrl+shift+r" = "layout_action rotate";
        "ctrl+shift+q" = "close_tab";
        "ctrl+shift+x" = "close_window";
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+n" = "new_tab";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+shift+h" = "neighboring_window left";
        "ctrl+shift+j" = "neighboring_window down";
        "ctrl+shift+k" = "neighboring_window up";
        "ctrl+shift+l" = "neighboring_window right";
        "ctrl+shift+t" = ''set_tab_title " "'';
        "ctrl+shift+down" = "no_op";
        "ctrl+shift+left" = "no_op";
        "ctrl+shift+right" = "no_op";
        "ctrl+shift+up" = "no_op";
      };
    };
  };
}
