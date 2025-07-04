{ lib, config, ... }:
{
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        default_layout = "compact";
        default_shell = "fish";
        mouse_mode = true;
        on_force_close = "detach";
        pane_frames = false;
        simplified_ui = true;
        show_startup_tips = false;
        session_name = "default";
        attach_to_session = true;
        keybinds =
          let
            zellij-navigator-version = "0.2.1";
            zellij-navigator = "https://github.com/hiasr/vim-zellij-navigator/releases/download/${zellij-navigator-version}/vim-zellij-navigator.wasm";
          in
          {
            "normal clear-defaults=true" = {
              "bind \"Ctrl h\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "move_focus";
                  payload = "left";
                };
              };
              "bind \"Ctrl j\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "move_focus";
                  payload = "down";
                };
              };
              "bind \"Ctrl k\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "move_focus";
                  payload = "up";
                };
              };
              "bind \"Ctrl l\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "move_focus";
                  payload = "right";
                };
              };
              "bind \"Alt h\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "resize";
                  payload = "left";
                };
              };
              "bind \"Alt j\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "resize";
                  payload = "down";
                };
              };
              "bind \"Alt k\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "resize";
                  payload = "up";
                };
              };
              "bind \"Alt l\"" = {
                "MessagePlugin \"${zellij-navigator}\"" = {
                  name = "resize";
                  payload = "right";
                };
              };
              "bind \"Ctrl Space\"" = {
                SwitchToMode = "Tmux";
              };
            };
            "renametab clear-defaults=true" = {
              "bind \"Esc\"" = {
                UndoRenameTab = { };
                SwitchToMode = "Normal";
              };
            };
            "scroll clear-defaults=true" = {
              "bind \"Enter\"" = {
                SwitchToMode = "Normal";
              };
              "bind \"Esc\"" = {
                SwitchToMode = "Normal";
              };
              "bind \"j\"" = {
                ScrollDown = { };
              };
              "bind \"k\"" = {
                ScrollUp = { };
              };
              "bind \"d\"" = {
                HalfPageScrollDown = { };
              };
              "bind \"u\"" = {
                HalfPageScrollUp = { };
              };
            };
            "tmux clear-defaults=true" = {
              "bind \"Ctrl Space\"" = {
                "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
                  floating = true;
                  move_to_focused_tab = true;
                };
                SwitchToMode = "Normal";
              };
              "bind \"Enter\"" = {
                SwitchToMode = "Normal";
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
                Quit = { };
              };
              "bind \"d\"" = {
                Detach = { };
              };
              "bind \"e\"" = {
                EditScrollback = { };
              };
              "bind \"f\"" = {
                ToggleFloatingPanes = { };
                SwitchToMode = "Normal";
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
                SwitchToMode = "Scroll";
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
