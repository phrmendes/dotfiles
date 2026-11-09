{
  flake.modules.homeManager.zellij =
    { config, lib, ... }:
    {
      programs.zellij = {
        enable = true;
        settings = {
          session_name = "default";
          attach_to_session = true;
          default_shell = "nu";
          simplified_ui = true;
          mouse_mode = true;
          scroll_buffer_size = 10000;
          copy_on_select = false;
          pane_frames = false;
          show_release_notes = false;
          show_startup_tips = false;
          plugins."welcome-screen" = {
            _props.location = "zellij:session-manager";
            welcome_screen = false;
          };
        };
        themes = lib.mkIf (config.stylix.targets.zellij.enable or false) (
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          {
            stylix.themes.default = {
              ribbon_unselected.emphasis_1 = lib.mkForce colors.base03;
              text_unselected.emphasis_0 = lib.mkForce colors.base04;
              ribbon_selected = {
                background = lib.mkForce colors.base09;
                emphasis_0 = lib.mkForce colors.base00;
                emphasis_1 = lib.mkForce colors.base00;
              };
            };
          }
        );
      };
    };
}
