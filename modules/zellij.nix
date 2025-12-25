{
  lib,
  config,
  inputs,
  ...
}:
{
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        default_layout = "compact";
        default_shell = "zsh";
        on_force_close = "detach";
        session_name = "default";
        mirror_session = false;
        attach_to_session = true;
        mouse_mode = true;
        pane_frames = false;
        show_release_notes = false;
        show_startup_tips = false;
        simplified_ui = true;
        post_command_discovery_hook = "echo \"$RESURRECT_COMMAND\" | sed 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g'";
      };
      extraConfig = ''
        compact-bar location="zellij:compact-bar" {
            tooltip "F1"
        }

        plugins {
            navigator location="file:${inputs.vim-zellij-navigator}" { }
        }

        load_plugins {
            navigator
        }

        keybinds {
            normal clear-defaults=true {
                bind "Alt h" {
                    MessagePlugin "navigator" {
                        name "resize"
                        payload "left"
                    }
                }
                bind "Alt j" {
                    MessagePlugin "navigator" {
                        name "resize"
                        payload "down"
                    }
                }
                bind "Alt k" {
                    MessagePlugin "navigator" {
                        name "resize"
                        payload "up"
                    }
                }
                bind "Alt l" {
                    MessagePlugin "navigator" {
                        name "resize"
                        payload "right"
                    }
                }
                bind "Ctrl Space" {
                    SwitchToMode "Tmux"
                }
                bind "Ctrl h" {
                    MessagePlugin "navigator" {
                        name "move_focus"
                        payload "left"
                    }
                }
                bind "Ctrl j" {
                    MessagePlugin "navigator" {
                        name "move_focus"
                        payload "down"
                    }
                }
                bind "Ctrl k" {
                    MessagePlugin "navigator" {
                        name "move_focus"
                        payload "up"
                    }
                }
                bind "Ctrl l" {
                    MessagePlugin "navigator" {
                        name "move_focus"
                        payload "right"
                    }
                }
            }
            renametab {
                bind "Esc" {
                    SwitchToMode "Normal"
                    UndoRenameTab
                }
            }
            scroll clear-defaults=true {
                bind "Enter" {
                    SwitchToMode "Normal"
                }
                bind "Esc" {
                    SwitchToMode "Normal"
                }
                bind "d" {
                    HalfPageScrollDown
                }
                bind "j" {
                    ScrollDown
                }
                bind "k" {
                    ScrollUp
                }
                bind "u" {
                    HalfPageScrollUp
                }
            }
            tmux clear-defaults=true {
                bind "-" {
                    NewPane "Down"
                    SwitchToMode "Normal"
                }
                bind "1" {
                    GoToTab 1
                    SwitchToMode "Normal"
                }
                bind "2" {
                    GoToTab 2
                    SwitchToMode "Normal"
                }
                bind "3" {
                    GoToTab 3
                    SwitchToMode "Normal"
                }
                bind "4" {
                    GoToTab 4
                    SwitchToMode "Normal"
                }
                bind "5" {
                    GoToTab 5
                    SwitchToMode "Normal"
                }
                bind "6" {
                    GoToTab 6
                    SwitchToMode "Normal"
                }
                bind "7" {
                    GoToTab 7
                    SwitchToMode "Normal"
                }
                bind "8" {
                    GoToTab 8
                    SwitchToMode "Normal"
                }
                bind "9" {
                    GoToTab 9
                    SwitchToMode "Normal"
                }
                bind "Ctrl Space" {
                    LaunchOrFocusPlugin "zellij:session-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "Normal"
                }
                bind "Enter" {
                    SwitchToMode "Normal"
                }
                bind "Esc" {
                    SwitchToMode "Normal"
                }
                bind "Q" {
                    Quit
                }
                bind "[" {
                    GoToPreviousTab; SwitchToMode "Normal"
                }
                bind "\\" {
                    NewPane "Right"
                    SwitchToMode "Normal"
                }
                bind "]" {
                    GoToNextTab; SwitchToMode "Normal"
                }
                bind "d" {
                    Detach
                }
                bind "e" {
                    EditScrollback
                }
                bind "f" {
                    SwitchToMode "Normal"
                    ToggleFloatingPanes
                }
                bind "h" {
                    MoveFocus "Left"
                    SwitchToMode "Normal"
                }
                bind "j" {
                    MoveFocus "Down"
                    SwitchToMode "Normal"
                }
                bind "k" {
                    MoveFocus "Up"
                    SwitchToMode "Normal"
                }
                bind "l" {
                    MoveFocus "Right"
                    SwitchToMode "Normal"
                }
                bind "m" {
                    SwitchToMode "Move"
                }
                bind "n" {
                    NewTab; SwitchToMode "Normal"
                }
                bind "q" {
                    CloseFocus; SwitchToMode "Normal"
                }
                bind "r" {
                    SwitchToMode "RenameTab"
                    TabNameInput 0
                }
                bind "s" {
                    SwitchToMode "Scroll"
                }
                bind "w" {
                    LaunchOrFocusPlugin "zellij:share" {
                        floating true
                        move_to_focused_tab true
                    }
                    SwitchToMode "Normal"
                }
                bind "z" {
                    ToggleFocusFullscreen; SwitchToMode "Normal"
                }
                bind "{" {
                    PreviousSwapLayout; SwitchToMode "Normal"
                }
                bind "}" {
                    NextSwapLayout; SwitchToMode "Normal"
                }
            }
        }
      '';
    };
  };
}
