{
  lib,
  config,
  pkgs,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = let
      zsh = lib.getExe pkgs.zsh;
    in {
      enable = true;
      settings = {
        default_layout = "compact";
        default_shell = "${zsh}";
        mouse_mode = true;
        on_force_close = "detach";
        pane_frames = false;
        simplified_ui = true;
        keybinds = {
          "normal clear-defaults=true" = {
            "bind \"Ctrl Space\"" = {
              SwitchToMode = "Tmux";
            };
            "bind \"Alt -\"" = {
              Resize = "Decrease";
            };
            "bind \"Alt =\"" = {
              Resize = "Increase";
            };
            "bind \"Alt [\"" = {
              "GoToPreviousTab; SwitchToMode" = "Normal";
            };
            "bind \"Alt ]\"" = {
              "GoToNextTab; SwitchToMode" = "Normal";
            };
            "bind \"Alt n\"" = {
              "NewTab; SwitchToMode" = "Normal";
            };
            "bind \"Alt q\"" = {
              "CloseFocus; SwitchToMode" = "Normal";
            };
            "bind \"Alt h\"" = {
              MoveFocus = "Left";
              SwitchToMode = "Normal";
            };
            "bind \"Alt j\"" = {
              MoveFocus = "Down";
              SwitchToMode = "Normal";
            };
            "bind \"Alt k\"" = {
              MoveFocus = "Up";
              SwitchToMode = "Normal";
            };
            "bind \"Alt l\"" = {
              MoveFocus = "Right";
              SwitchToMode = "Normal";
            };
            "bind \"Alt 1\"" = {
              "GoToTab" = 1;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 2\"" = {
              "GoToTab" = 2;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 3\"" = {
              "GoToTab" = 3;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 4\"" = {
              "GoToTab" = 4;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 5\"" = {
              "GoToTab" = 5;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 6\"" = {
              "GoToTab" = 6;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 7\"" = {
              "GoToTab" = 7;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 8\"" = {
              "GoToTab" = 8;
              "SwitchToMode" = "Normal";
            };
            "bind \"Alt 9\"" = {
              "GoToTab" = 9;
              "SwitchToMode" = "Normal";
            };
          };
          "tmux clear-defaults=true" = {
            "bind \"-\"" = {
              NewPane = "Down";
              SwitchToMode = "Normal";
            };
            "bind \"\\\\\"" = {
              NewPane = "Right";
              SwitchToMode = "Normal";
            };
            "bind \"}\"" = {
              "NextSwapLayout; SwitchToMode" = "Normal";
            };
            "bind \"{\"" = {
              "PreviousSwapLayout; SwitchToMode" = "Normal";
            };
            "bind \"Enter\"" = {
              SwitchToMode = "Resize";
            };
            "bind \"Esc\"" = {
              SwitchToMode = "Normal";
            };
            "bind \"Q\"" = {
              Quit = {};
            };
            "bind \"S\"" = {
              SwitchToMode = "Scroll";
            };
            "bind \"d\"" = {
              Detach = {};
            };
            "bind \"m\"" = {
              SwitchToMode = "Move";
            };
            "bind \"q\"" = {
              "CloseFocus; SwitchToMode" = "Normal";
            };
            "bind \"r\"" = {
              SwitchToMode = "RenameTab";
              TabNameInput = 0;
            };
            "bind \"z\"" = {
              "ToggleFocusFullscreen; SwitchToMode" = "Normal";
            };
            "bind \"s\"" = {
              "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
                floating = true;
                move_to_focused_tab = true;
              };
              SwitchToMode = "Normal";
            };
          };
        };
      };
    };
  };
}
