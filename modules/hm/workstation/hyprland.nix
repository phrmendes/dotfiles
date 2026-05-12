let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ cmd;
  noctaliaExec = cmd: builtins.concatStringsSep " " (noctalia cmd);
  directionalBinds = modifiers: action: [
    "${modifiers}H,${action},l"
    "${modifiers}J,${action},d"
    "${modifiers}K,${action},u"
    "${modifiers}L,${action},r"
  ];
  workspaceBinds =
    modifiers: action: ws:
    ws |> map (x: "${modifiers}${toString x},${action},${toString x}");
in
{
  modules.homeManager.workstation.hyprland =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      inherit (lib) getExe;
      inherit (osConfig.machine) isLaptop;
      inherit (osConfig.machine) monitors;
      playerctl = getExe pkgs.playerctl;
      ws = lib.range 1 9;
      mediaBinds = [
        ",XF86AudioPlay,exec,${playerctl} play-pause"
        ",XF86AudioPause,exec,${playerctl} play-pause"
        ",XF86AudioPrev,exec,${playerctl} previous"
        ",XF86AudioNext,exec,${playerctl} next"
      ];
      focusBinds = directionalBinds "SUPER," "movefocus";
      moveBinds = directionalBinds "SUPER SHIFT," "movewindoworgroup";
      workspaceCycleBinds = [
        "SUPER CTRL,H,workspace,r-1"
        "SUPER CTRL,L,workspace,r+1"
        "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
        "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
      ];
      workspace = {
        move = workspaceBinds "SUPER SHIFT," "movetoworkspace" ws;
        switch = workspaceBinds "SUPER," "workspace" ws;
        moveSilent = workspaceBinds "SUPER SHIFT CTRL," "movetoworkspacesilent" ws;
      };
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = false;
          enableXdgAutostart = true;
        };
        settings = {
          exec-once = [ "noctalia-shell" ];
          debug.damage_tracking = 2;
          input = {
            kb_layout = "us,br";
            kb_model = "pc104";
            kb_rules = "evdev";
            kb_options = "grp:alt_space_toggle";
            numlock_by_default = true;
            follow_mouse = 1;
            sensitivity = 0;
            touchpad.natural_scroll = true;
          };
          general = {
            gaps_in = 3;
            gaps_out = 8;
            border_size = 2;
            layout = "dwindle";
            resize_on_border = true;
          };
          decoration = {
            active_opacity = 1;
            inactive_opacity = 0.9;
            rounding = 10;
            rounding_power = 2;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = lib.mkForce "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = 3;
              passes = 2;
              vibrancy = 0.1696;
            };
          };
          animations.enabled = true;
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
          misc = {
            vfr = 0;
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };
          monitor =
            with monitors;
            let
              monitorStr =
                m: "${m.name},${m.resolution}@${toString m.refreshRate},${m.position},${toString m.scale}";
            in
            [ (monitorStr primary) ] ++ lib.optional (secondary != null) (monitorStr secondary);
          windowrule = [
            "float on, opaque on, match:class (.blueman-manager-wrapped)"
            "float on, stay_focused on, opaque on, match:class (org.pulseaudio.pavucontrol)"
            "float on, match:title ^(Picture-in-Picture)$"
            "opaque on, match:class (firefox)"
            "opaque on, match:class (mpv)"
          ];
          layerrule = [
            {
              name = "noctalia";
              "match:namespace" = "noctalia-background-.*$";
              ignore_alpha = 0.5;
              blur = true;
              blur_popups = true;
            }
            {
              name = "noctalia-screenshot";
              "match:namespace" = "noctalia-shell:regionSelector";
              no_anim = true;
            }
          ];
          workspace =
            with monitors;
            let
              secondaryName = (if secondary != null then secondary else primary).name;
            in
            [
              "1,monitor:${primary.name}"
              "2,monitor:${primary.name}"
              "3,monitor:${primary.name}"
              "4,monitor:${primary.name}"
              "5,monitor:${primary.name}"
              "6,monitor:${primary.name}"
              "7,monitor:${primary.name}"
              "8,monitor:${secondaryName}"
              "9,monitor:${secondaryName}"
            ];
          bindm = [
            "SUPER,mouse:272,movewindow"
            "SUPER,mouse:273,resizewindow"
          ];
          binde = [
            ",XF86AudioRaiseVolume,exec,${
              noctaliaExec [
                "volume"
                "increase"
              ]
            }"
            ",XF86AudioLowerVolume,exec,${
              noctaliaExec [
                "volume"
                "decrease"
              ]
            }"
            ",XF86AudioMute,exec,${
              noctaliaExec [
                "volume"
                "muteOutput"
              ]
            }"
            ",XF86AudioMicMute,exec,${
              noctaliaExec [
                "volume"
                "muteInput"
              ]
            }"
          ]
          ++ lib.optionals isLaptop [
            ",XF86MonBrightnessUp,exec,${
              noctaliaExec [
                "brightness"
                "increase"
              ]
            }"
            ",XF86MonBrightnessDown,exec,${
              noctaliaExec [
                "brightness"
                "decrease"
              ]
            }"
          ]
          ++ [
            "SUPER ALT,h,resizeactive,-20 0"
            "SUPER ALT,j,resizeactive,0 20"
            "SUPER ALT,k,resizeactive,0 -20"
            "SUPER ALT,l,resizeactive,20 0"
          ];
          bind = [
            ",print,exec,${
              noctaliaExec [
                "plugin:screen-shot-and-record"
                "screenshot"
              ]
            }"
            "SHIFT,print,exec,${
              noctaliaExec [
                "plugin:screen-shot-and-record"
                "record"
              ]
            }"
            "SUPER,space,exec,${
              noctaliaExec [
                "launcher"
                "toggle"
              ]
            }"
            "SUPER,V,exec,${
              noctaliaExec [
                "plugin:clipboard"
                "toggle"
              ]
            }"
            "SUPER,tab,changegroupactive,f"
            "SUPER,return,exec,${getExe pkgs.kitty}"
            "SUPER,B,exec,${getExe config.programs.firefox.package}"
            "SUPER,F,togglefloating"
            "SUPER,G,togglegroup"
            "SUPER,P,pseudo"
            "SUPER,Q,killactive"
            "SUPER,R,togglesplit"
            "SUPER,T,lockactivegroup,toggle"
            "SUPER,Z,fullscreen"
            "CTRL ALT,L,exec,${
              noctaliaExec [
                "lockScreen"
                "lock"
              ]
            }"
          ]
          ++ mediaBinds
          ++ focusBinds
          ++ moveBinds
          ++ workspaceCycleBinds
          ++ workspace.switch
          ++ workspace.move
          ++ workspace.moveSilent;
          env = [
            "GDK_BACKEND,wayland"
            "MOZ_ENABLE_WAYLAND,1"
            "NIXOS_OZONE_WL,1"
            "QT_QPA_PLATFORM,wayland"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "SDL_VIDEODRIVER,wayland"
            "USE_WAYLAND_GRIM,1"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "QT_ICON_THEME,Papirus-Dark"
          ]
          ++ lib.optionals (!isLaptop) [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "WLR_NO_HARDWARE_CURSORS,1"
          ];
        };
      };
    };
}
