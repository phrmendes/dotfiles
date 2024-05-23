{
  lib,
  config,
  pkgs,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_layout = "compact";
        copy_clipboard = "primary";
        copy_on_select = true;
        default_shell = "${lib.getExe pkgs.zsh}";
        mouse_mode = true;
        pane_frames = false;
        simplified_ui = true;
        ui.pane_frames.hide_session_name = true;
        keybinds = {
          "normal clear-defaults=true" = {
            "bind \"Alt H\"" = {"Resize \"Increase Left\"" = {};};
            "bind \"Alt J\"" = {"Resize \"Increase Down\"" = {};};
            "bind \"Alt K\"" = {"Resize \"Increase Up\"" = {};};
            "bind \"Alt L\"" = {"Resize \"Increase Right\"" = {};};
            "bind \"Alt h\"" = {"MoveFocus \"Left\"" = {};};
            "bind \"Alt j\"" = {"MoveFocus \"Down\"" = {};};
            "bind \"Alt k\"" = {"MoveFocus \"Up\"" = {};};
            "bind \"Alt l\"" = {"MoveFocus \"Right\"" = {};};
            "bind \"Alt [\"" = {GoToPreviousTab = {};};
            "bind \"Alt ]\"" = {GoToNextTab = {};};
            "bind \"Alt x\"" = {CloseFocus = {};};
            "bind \"Alt d\"" = {Detach = {};};
            "bind \"Alt f\"" = {ToggleFloatingPanes = {};};
            "bind \"Alt n\"" = {NewPane = {};};
            "bind \"Alt q\"" = {Quit = {};};
            "bind \"Alt t\"" = {NewTab = {};};
            "bind \"Alt z\"" = {ToggleFocusFullscreen = {};};
            "bind \"Alt r\"" = {
              "SwitchToMode \"RenameTab\"" = {};
              "TabNameInput 0" = {};
            };
            "bind \"Alt s\"" = {
              "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
                floating = true;
                move_to_focused_tab = true;
              };
            };
          };
          renametab = {
            "bind \"Esc\"" = {"SwitchToMode \"Normal\"" = {};};
          };
        };
      };
    };
  };
}
