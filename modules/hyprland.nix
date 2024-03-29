{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = let
      wallpaper = ../dotfiles/wallpaper.png;
      colors = import ./catppuccin.nix;
      range = [1 2 3 4 5 6 7 8 9];
      switchToWorkspace = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") range;
      moveToWorkspaceSilent = map (x: "SUPER SHIFT CTRL, ${builtins.toString x}, movetoworkspacesilent, ${builtins.toString x}") range;
      moveToWorkspace = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}") range;
      startupScript = pkgs.writeShellScriptBin "start" ''
        ${lib.getExe pkgs.swaybg} --image ${wallpaper} --mode fill
      '';
      powermenuScript = pkgs.writeShellScriptBin "powermenu" ''
        lock="  Lock"
        suspend="󰤄  Suspend"
        restart="  Restart"
        poweroff="󰐥  Power off"

        option=$(printf "$lock\n$suspend\n$restart\n$poweroff" | ${lib.getExe pkgs.rofi} -dmenu -i -p "   Powermenu  ")

        if [ "$option" == "$lock" ]; then
          ${pkgs.systemd}/bin/loginctl lock-session
        elif [ "$option" == "$suspend" ]; then
          ${pkgs.systemd}/bin/systemctl suspend
        elif [ "$option" == "$restart" ]; then
          ${pkgs.systemd}/bin/systemctl reboot
        elif [ "$option" == "$poweroff" ]; then
          ${pkgs.systemd}/bin/systemctl poweroff
        fi
      '';
      screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
        print_path="$HOME/Pictures/Screenshots"
        filename=$(date "+%Y%m%d-%H:%M:%S")
        region_selector=$(${lib.getExe pkgs.slurp})
        grab_image=${lib.getExe pkgs.grim}
        annotator=${lib.getExe pkgs.satty}

        $grab_image -g "$region_selector" - | $annotator --filename - --output-filename "$print_path/$filename".png
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
          "float,class:(copyq)"
          "float,class:(gcolor3)"
          "float,class:(nwg-displays)"
          "float,class:(nwg-look)"
          "float,class:(pavucontrol)"
          "float,class:(rofi)"
          "float,class:(satty)"
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
          ",XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
          # resize
          "SUPER ALT,left,resizeactive,-20 0"
          "SUPER ALT,right,resizeactive,20 0"
          "SUPER ALT,up,resizeactive,0 -20"
          "SUPER ALT,down,resizeactive,0 20"
        ];
        bind =
          [
            # apps
            "SUPER SHIFT,V,exec,copyq toggle"
            "SUPER,C,exec,dunstctl close-all"
            "SUPER,W,exec,rofi -show window"
            "SUPER,escape,exec,${powermenuScript}/bin/powermenu"
            "SUPER,return,exec,kitty"
            "SUPER,space,exec,rofi -show drun"
            ",print,exec,${screenshotScript}/bin/screenshot"
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
            "SUPER SHIFT,H,movewindow,l"
            "SUPER SHIFT,L,movewindow,r"
            "SUPER SHIFT,K,movewindow,u"
            "SUPER SHIFT,J,movewindow,d"
            # workspaces
            "SUPER CTRL,H,workspace,r-1"
            "SUPER CTRL,L,workspace,r+1"
            "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
            "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
            # media keys
            ",XF86AudioMute,exec,${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
            ",XF86AudioPlay,exec,${lib.getExe pkgs.playerctl} play-pause"
            ",XF86AudioNext,exec,${lib.getExe pkgs.playerctl} next"
            ",XF86AudioPrev,exec,${lib.getExe pkgs.playerctl} previous"
          ]
          ++ switchToWorkspace
          ++ moveToWorkspace
          ++ moveToWorkspaceSilent;
      };
    };
  };
}
