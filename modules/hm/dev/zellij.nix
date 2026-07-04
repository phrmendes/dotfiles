_: {
  modules.homeManager.dev.zellij =
    _:
    {
      programs.zellij = {
        enable = true;
        enableZshIntegration = true;
        attachExistingSession = true;
        exitShellOnExit = false;
        extraConfig = builtins.readFile ../../../files/zellij.kdl;
        settings = {
          mouse_mode = true;
          scroll_buffer_size = 10000;
          copy_on_select = false;
          pane_frames = false;
          default_mode = "locked";
          default_layout = "compact";
        };
      };
    };
}
