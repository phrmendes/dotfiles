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
          };
          "tmux clear-defaults=true" = {
            "bind \"Enter\"" = {
              SwitchToMode = "Resize";
            };
            "bind \"Esc\"" = {
              SwitchToMode = "Normal";
            };
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
            "bind \"[\"" = {
              "GoToPreviousTab; SwitchToMode" = "Normal";
            };
            "bind \"]\"" = {
              "GoToNextTab; SwitchToMode" = "Normal";
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
            "bind \"h\"" = {
              MoveFocus = "Left";
              SwitchToMode = "Normal";
            };
            "bind \"j\"" = {
              MoveFocus = "Down";
              SwitchToMode = "Normal";
            };
            "bind \"k\"" = {
              MoveFocus = "Up";
              SwitchToMode = "Normal";
            };
            "bind \"l\"" = {
              MoveFocus = "Right";
              SwitchToMode = "Normal";
            };
            "bind \"m\"" = {
              SwitchToMode = "Move";
            };
            "bind \"n\"" = {
              "NewTab; SwitchToMode" = "Normal";
            };
            "bind \"q\"" = {
              "CloseFocus; SwitchToMode" = "Normal";
            };
            "bind \"r\"" = {
              SwitchToMode = "RenameTab";
              TabNameInput = 0;
            };
            "bind \"s\"" = {
              "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
                floating = true;
                move_to_focused_tab = true;
              };
              SwitchToMode = "Normal";
            };
            "bind \"z\"" = {
              "ToggleFocusFullscreen; SwitchToMode" = "Normal";
            };
            "bind \"1\"" = {
              "GoToTab" = 1;
              "SwitchToMode" = "Normal";
            };
            "bind \"2\"" = {
              "GoToTab" = 2;
              "SwitchToMode" = "Normal";
            };
            "bind \"3\"" = {
              "GoToTab" = 3;
              "SwitchToMode" = "Normal";
            };
            "bind \"4\"" = {
              "GoToTab" = 4;
              "SwitchToMode" = "Normal";
            };
            "bind \"5\"" = {
              "GoToTab" = 5;
              "SwitchToMode" = "Normal";
            };
            "bind \"6\"" = {
              "GoToTab" = 6;
              "SwitchToMode" = "Normal";
            };
            "bind \"7\"" = {
              "GoToTab" = 7;
              "SwitchToMode" = "Normal";
            };
            "bind \"8\"" = {
              "GoToTab" = 8;
              "SwitchToMode" = "Normal";
            };
            "bind \"9\"" = {
              "GoToTab" = 9;
              "SwitchToMode" = "Normal";
            };
          };
        };
      };
    };
  };
}
