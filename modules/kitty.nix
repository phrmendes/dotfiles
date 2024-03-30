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
      font_family = "FiraCode Nerd Font Mono";
      font_size =
        if isDarwin
        then 16
        else 13;
    in {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "${font_family} Light";
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
        bold_font = "${font_family} SemBd";
        bold_italic_font = "${font_family} SemBd Italic";
        enable_audio_bell = false;
        enabled_layouts = "splits:split_axis=horizontal,stack";
        inactive_text_alpha = "0.9";
        italic_font = "${font_family} Italic";
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
        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+j" = "move_window down";
        "ctrl+shift+k" = "move_window up";
        "ctrl+shift+l" = "move_window right";
        "ctrl+shift+w" = "new_os_window";
        "ctrl+shift+q" = "close_os_window";
        "ctrl+shift+x" = "close_tab";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "alt+-" = "launch --location=hsplit --cwd=current";
        "alt+\\" = "launch --location=vsplit --cwd=current";
        "alt+x" = "close_window";
        "alt+[" = "previous_window";
        "alt+]" = "next_window";
        "alt+=" = "resize_window reset";
        "alt+left" = "resize_window narrower";
        "alt+down" = "resize_window shorter";
        "alt+up" = "resize_window taller";
        "alt+right" = "resize_window wider";
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";
      };
    };
  };
}
