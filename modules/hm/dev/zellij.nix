_: {
  modules.homeManager.dev.zellij = _: {
    programs.zellij = {
      enable = true;
      exitShellOnExit = false;
      settings = {
        mouse_mode = true;
        scroll_buffer_size = 10000;
        copy_on_select = false;
        pane_frames = false;
        default_mode = "locked";
        default_layout = "compact";
        show_release_notes = false;
        show_startup_tips = false;
      };
      extraConfig = builtins.readFile ../../../files/zellij.kdl;
    };
  };
}
