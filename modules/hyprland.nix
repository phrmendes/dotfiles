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
      brightnessctl = lib.getExe pkgs.brightnessctl;
      kitty = getExe pkgs.kitty;
      playerctl = getExe pkgs.playerctl;
      swaylock = getExe pkgs.swaylock;
      wofi = getExe pkgs.wofi;
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      dmenu = "${getExe pkgs.wofi} --show dmenu";
      screenshot = ''${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe pkgs.satty} --filename -'';
      clipboard = ''${getExe pkgs.cliphist} list | ${dmenu} | ${getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy'';
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
          "${primary},preferred,auto,1"
          (lib.mkIf (!parameters.laptop) "${secondary},preferred,auto-left,1")
        ];
        windowrulev2 = [
          "float,stayfocused,class:(satty)"
          "float,stayfocused,opaque,class:(pavucontrol)"
          "float,stayfocused,opaque,class:(wofi)"
          "float,title:(Picture-in-Picture)"
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
          (
            if parameters.laptop
            then "9,monitor:${primary}"
            else "9,monitor:${secondary}"
          )
        ];
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        binde = [
          ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
          (lib.mkIf parameters.laptop ",XF86MonBrightnessUp,exec,${brightnessctl} set +5%")
          (lib.mkIf parameters.laptop ",XF86MonBrightnessDown,exec,${brightnessctl} set 5%-")
          "SUPER ALT,h,resizeactive,-20 0"
          "SUPER ALT,j,resizeactive,0 20"
          "SUPER ALT,k,resizeactive,0 -20"
          "SUPER ALT,l,resizeactive,20 0"
        ];
        bind =
          [
            "CTRL ALT, L, exec, ${swaylock}"
            ",print,exec,${screenshot}"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioPause,exec,${playerctl} play-pause"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioNext,exec,${playerctl} next"
            "SUPER,space,exec,${wofi}"
            "SUPER,tab,changegroupactive,f"
            "SUPER,return,exec,${kitty}"
            "SUPER,V,exec,${clipboard}"
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
