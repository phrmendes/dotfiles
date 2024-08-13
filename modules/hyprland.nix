{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = let
      inherit (lib) getExe;
      powermenu = pkgs.writeScriptBin "powermenu" (builtins.readFile ../dotfiles/powermenu.sh);
      copyq = getExe pkgs.copyq;
      grim = getExe pkgs.grim;
      wezterm = getExe pkgs.wezterm;
      playerctl = getExe pkgs.playerctl;
      satty = getExe pkgs.satty;
      slurp = getExe pkgs.slurp;
      swaylock = getExe pkgs.swaylock;
      dunstctl = "${pkgs.dunst}/bin/dunstctl";
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      rofi = "${pkgs.rofi-wayland}/bin/rofi -theme gruvbox-dark";
      screenshot = ''${grim} -g "$(${slurp})" - | ${satty} --filename -'';
      workspace = rec {
        workspaces = [1 2 3 4 5 6 7 8 9];
        move = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}") workspaces;
        switch = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") workspaces;
        moveSilent = map (x: "SUPER SHIFT CTRL, ${builtins.toString x}, movetoworkspacesilent, ${builtins.toString x}") workspaces;
      };
    in {
      enable = true;
      settings = {
        input = {
          kb_layout = "us,br";
          kb_model = "pc104";
          kb_rules = "evdev";
          kb_options = "grp:alt_space_toggle";
          numlock_by_default = true;
          follow_mouse = 1;
          sensitivity = 0;
        };
        general = {
          gaps_in = 3;
          gaps_out = 6;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
        };
        decoration = {
          active_opacity = 1;
          inactive_opacity = 0.9;
          rounding = 10;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };
        monitor = with parameters.monitors; [
          "${primary},1920x1080,1366x0,1"
          "${secondary},1366x768,0x0,auto"
        ];
        windowrulev2 = [
          "float,stayfocused,class:(gcolor3)"
          "float,stayfocused,class:(pavucontrol)"
          "float,stayfocused,class:(satty)"
          "float,stayfocused,opaque,class:(copyq)"
          "float,stayfocused,opaque,class:(rofi)"
          "opaque,class:(chromium)"
          "opaque,class:(firefox)"
          "opaque,class:(vlc)"
        ];
        workspace = with parameters.monitors; [
          "1,monitor:${primary}"
          "2,monitor:${primary}"
          "3,monitor:${primary}"
          "4,monitor:${primary}"
          "5,monitor:${primary}"
          "6,monitor:${primary}"
          "7,monitor:${primary}"
          "8,monitor:${primary}"
          "9,monitor:${secondary}"
        ];
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        binde = [
          ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
          "SUPER ALT,h,resizeactive,-20 0"
          "SUPER ALT,j,resizeactive,0 20"
          "SUPER ALT,k,resizeactive,0 -20"
          "SUPER ALT,l,resizeactive,20 0"
        ];
        bind =
          [
            ",print,exec,${screenshot}"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioPause,exec,${playerctl} play-pause"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioNext,exec,${playerctl} next"
            "CTRL ALT, L, exec, ${swaylock}"
            "SUPER,space,exec,${rofi} -show drun"
            "SUPER,tab,changegroupactive,f"
            "SUPER,escape,exec,${getExe powermenu}"
            "SUPER,return,exec,${wezterm}"
            "SUPER,B,exec,${rofi} -show recursivebrowser"
            "SUPER,C,exec,${dunstctl} close-all"
            "SUPER,N,exec,${dunstctl} set-paused toggle"
            "SUPER,V,exec,${copyq} toggle"
            "SUPER,W,exec,${rofi} -show window"
            "SUPER,F,togglefloating"
            "SUPER,G,togglegroup"
            "SUPER,H,movefocus,l"
            "SUPER,J,movefocus,d"
            "SUPER,K,movefocus,u"
            "SUPER,L,movefocus,r"
            "SUPER,P,pseudo"
            "SUPER,Q,killactive"
            "SUPER,R,togglesplit"
            "SUPER,T,lockactivegroup,toggle"
            "SUPER,Z,fullscreen"
            "SUPER CTRL,H,workspace,r-1"
            "SUPER CTRL,L,workspace,r+1"
            "SUPER SHIFT,H,movewindoworgroup,l"
            "SUPER SHIFT,J,movewindoworgroup,d"
            "SUPER SHIFT,K,movewindoworgroup,u"
            "SUPER SHIFT,L,movewindoworgroup,r"
            "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
            "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
          ]
          ++ workspace.switch
          ++ workspace.move
          ++ workspace.moveSilent;
      };
    };
  };
}
