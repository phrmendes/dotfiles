{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  font_family = "FiraCode Nerd Font Mono";
  font_size =
    if isDarwin
    then 14
    else 12;
in {
  programs.kitty = {
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
      allow_remote_control = "socket-only";
      bell_on_tab = false;
      enable_audio_bell = false;
      listen_on = "unix:/tmp/kitty";
      open_url_with = "default";
      scrollback_lines = 10000;
      undercurl_style = "thin-sparse";
      update_check_interval = 0;
      window_padding_width = 6;
      bold_font = "${font_family} SemBd";
      italic_font = "${font_family} Italic";
      bold_italic_font = "${font_family} SemBd Italic";
      font_size = font_size;
    };
    keybindings = {
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+shift+h" = "discard_event";
      "ctrl+shift+n" = "discard_event";
      "ctrl+shift+r" = "discard_event";
      "ctrl+shift+t" = "discard_event";
      "ctrl+shift+w" = "discard_event";
      "ctrl+shift+space" = "discard_event";
    };
  };
}
