{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      simplified_ui = true;
      default_shell = "zsh";
      mouse_mode = true;
      ui.pane_frames.hide_session_name = true;
    };
  };
}