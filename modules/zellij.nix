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
        hide_session_name = true;
        mouse_mode = true;
        on_force_close = "detach";
        pane_frames = false;
        simplified_ui = true;
        keybinds = {
          "normal clear-defaults=true" = {
            "bind \"Ctrl Space\"" = {
              SwitchToMode = "Tmux";
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
          };
          "tmux clear-defaults=true" = {
            "bind \"Ctrl Space\"" = {
              Write = 2;
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
            "bind \"/\"" = {
              SwitchToMode = "Scroll";
            };
            "bind \"[\"" = {
              "GoToPreviousTab; SwitchToMode" = "Normal";
            };
            "bind \"]\"" = {
              "GoToNextTab; SwitchToMode" = "Normal";
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
            "bind \"d\"" = {
              Detach = {};
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
          };
        };
      };
    };
  };
}
