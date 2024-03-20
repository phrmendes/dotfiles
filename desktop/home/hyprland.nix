{pkgs, ...}: {
  wayland.windowManager.hyprland = let
    wallpaper = ../../dotfiles/wallpaper.png;
    colors = import ../../shared/catppuccin.nix;
    range = [1 2 3 4 5 6 7 8 9];
    switchToWorkspace = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") range;
    moveToWorkspaceSilent = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspacesilent, ${builtins.toString x}") range;
    moveToWorkspace = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}") range;
    startupScript = pkgs.writeShellScriptBin "start" ''
      swaybg --image ${wallpaper} --mode fill
    '';
    powermenuScript = pkgs.writeShellScriptBin "powermenu" ''
      lock="  Lock"
      suspend="󰤄  Suspend"
      restart="  Restart"
      poweroff="󰐥  Power off"

      option=$(printf "$lock\n$suspend\n$restart\n$poweroff" | rofi -dmenu -i -p "   Powermenu  ")

      if [ "$option" == "$lock" ]; then
        swaylock
      elif [ "$option" == "$suspend" ]; then
        systemctl suspend
      elif [ "$option" == "$restart" ]; then
        systemctl reboot
      elif [ "$option" == "$poweroff" ]; then
        systemctl poweroff
      fi
    '';
  in {
    enable = true;
    settings = with colors.catppuccin.palette; {
      exec-once = "${startupScript}/bin/start";
      input = {
        kb_layout = "us,br";
        kb_model = "pc104";
        kb_options = "grp:alt_space_toggle";
        kb_rules = "evdev";
        follow_mouse = 1;
        sensitivity = 0;
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgba(${blue}ff) rgba(${green}ff) 60deg";
      };
      decoration = {
        active_opacity = 1;
        inactive_opacity = 0.9;
        rounding = 10;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(${base}ff)";
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
      monitor = [
        "DP-2,1366x768,0x0,auto"
        "HDMI-A-1,1920x1080,1366x0,auto"
      ];
      windowrulev2 = [
        "float,class:(gcolor3)"
        "float,class:(nwg-displays)"
        "float,class:(nwg-look)"
        "float,class:(rofi)"
        "float,class:(copyq)"
      ];
      workspace = [
        "1,monitor:HDMI-A-1"
        "2,monitor:HDMI-A-1"
        "3,monitor:HDMI-A-1"
        "4,monitor:HDMI-A-1"
        "5,monitor:HDMI-A-1"
        "6,monitor:HDMI-A-1"
        "7,monitor:HDMI-A-1"
        "8,monitor:HDMI-A-1"
        "9,monitor:DP-2"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
      binde = [
        # volume keys
        ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
        # resize
        "SUPER CTRL,left,resizeactive,-10 0"
        "SUPER CTRL,right,resizeactive,10 0"
        "SUPER CTRL,up,resizeactive,0 -10"
        "SUPER CTRL,down,resizeactive,0 10"
      ];
      bind =
        [
          # apps
          "SUPER,escape,exec,rofi -show power-menu"
          "SUPER,space,exec,rofi -show drun"
          "SUPER,W,exec,rofi -show window"
          "SUPER,return,exec,kitty"
          "SUPER,E,exec,thunar"
          "SUPER,C,exec,dunstctl close-all"
          "SUPER,f4,exec,${powermenuScript}/bin/powermenu"
          "SUPER SHIFT,V,exec,copyq toggle"
          '',print,exec,grim -g "$(slurp)" - | satty -f -''
          # general operations
          "SUPER,F,togglefloating"
          "SUPER,P,pseudo"
          "SUPER,Q,killactive"
          "SUPER,T,togglesplit"
          "SUPER,Z,fullscreen"
          # windows
          "SUPER,H,movefocus,l"
          "SUPER,J,movefocus,d"
          "SUPER,K,movefocus,u"
          "SUPER,L,movefocus,r"
          # workspaces
          "SUPER CTRL,H,workspace,r-1"
          "SUPER CTRL,L,workspace,r+1"
          "SUPER ALT,H,movetoworkspace,r-1"
          "SUPER ALT,L,movetoworkspace,r+1"
          # media keys
          ",XF86AudioMute,exec,pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioPlay,exec,playerctl play-pause"
          ",XF86AudioNext,exec,playerctl next"
          ",XF86AudioPrev,exec,playerctl previous"
        ]
        ++ switchToWorkspace
        ++ moveToWorkspace
        ++ moveToWorkspaceSilent;
    };
  };
}
