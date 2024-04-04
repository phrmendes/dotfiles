{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  options.kitty.enable = lib.mkEnableOption "enable kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = let
      font_size =
        if isDarwin
        then 16
        else 12;
    in {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "FiraCode Nerd Font Mono";
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
        bold_font = "auto";
        bold_italic_font = "auto";
        enable_audio_bell = false;
        enabled_layouts = "splits:split_axis=horizontal,stack";
        inactive_text_alpha = "0.9";
        italic_font = "auto";
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
        "ctrl+shift+h" = "neighboring_window left";
        "ctrl+shift+j" = "neighboring_window down";
        "ctrl+shift+k" = "neighboring_window up";
        "ctrl+shift+l" = "neighboring_window right";
        "ctrl+shift+left" = "move_window left";
        "ctrl+shift+down" = "move_window down";
        "ctrl+shift+up" = "move_window up";
        "ctrl+shift+right" = "move_window right";
        "ctrl+shift+enter" = "new_os_window";
        "ctrl+shift+q" = "close_tab";
        "ctrl+shift+r" = "start_resizing_window";
        "ctrl+shift+x" = "close_window";
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+shift+equal" = "resize_window reset";
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
      };
    };
  };
}
