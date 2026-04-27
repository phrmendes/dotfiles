let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ cmd;
in
{
  modules = {
    nixos.workstation.hyprland = {
      programs = {
        dconf.enable = true;
        hyprland = {
          enable = true;
          withUWSM = true;
        };
      };
    };

    homeManager.workstation = {
      hyprland =
        {
          pkgs,
          lib,
          config,
          osConfig,
          ...
        }:
        let
          inherit (lib) getExe;
          isLaptop = osConfig.machine.type == "laptop";
          inherit (osConfig.machine) monitors;
          playerctl = getExe pkgs.playerctl;
          ws = lib.range 1 9;
          mediaBinds = [
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioPause,exec,${playerctl} play-pause"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioNext,exec,${playerctl} next"
          ];
          focusBinds = [
            "SUPER,H,movefocus,l"
            "SUPER,J,movefocus,d"
            "SUPER,K,movefocus,u"
            "SUPER,L,movefocus,r"
          ];
          moveBinds = [
            "SUPER SHIFT,H,movewindoworgroup,l"
            "SUPER SHIFT,J,movewindoworgroup,d"
            "SUPER SHIFT,K,movewindoworgroup,u"
            "SUPER SHIFT,L,movewindoworgroup,r"
          ];
          workspaceCycleBinds = [
            "SUPER CTRL,H,workspace,r-1"
            "SUPER CTRL,L,workspace,r+1"
            "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
            "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
          ];
          workspace = {
            move = ws |> map (x: "SUPER SHIFT, ${toString x}, movetoworkspace, ${toString x}");
            switch = ws |> map (x: "SUPER, ${toString x}, workspace, ${toString x}");
            moveSilent = ws |> map (x: "SUPER SHIFT CTRL, ${toString x}, movetoworkspacesilent, ${toString x}");
          };
        in
        {
          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enableXdgAutostart = true;
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
              monitor = with monitors; [
                "${primary.name},${primary.resolution},${primary.position},1"
                (lib.mkIf (secondary != null) "${secondary.name},${secondary.resolution},${secondary.position},1")
              ];
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
                  lib.concatStringsSep " " (noctalia [
                    "volume"
                    "increase"
                  ])
                }"
                ",XF86AudioLowerVolume,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "volume"
                    "decrease"
                  ])
                }"
                ",XF86AudioMute,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "volume"
                    "muteOutput"
                  ])
                }"
                ",XF86AudioMicMute,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "volume"
                    "muteInput"
                  ])
                }"
                (lib.mkIf isLaptop ",XF86MonBrightnessUp,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "brightness"
                    "increase"
                  ])
                }")
                (lib.mkIf isLaptop ",XF86MonBrightnessDown,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "brightness"
                    "decrease"
                  ])
                }")
                "SUPER ALT,h,resizeactive,-20 0"
                "SUPER ALT,j,resizeactive,0 20"
                "SUPER ALT,k,resizeactive,0 -20"
                "SUPER ALT,l,resizeactive,20 0"
              ];
              bind = [
                ",print,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "plugin:screen-shot-and-record"
                    "screenshot"
                  ])
                }"
                "SUPER,space,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "launcher"
                    "toggle"
                  ])
                }"
                "SUPER,V,exec,${
                  lib.concatStringsSep " " (noctalia [
                    "plugin:clipboard"
                    "toggle"
                  ])
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
                  lib.concatStringsSep " " (noctalia [
                    "lockScreen"
                    "lock"
                  ])
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
                "NVD_BACKEND,direct"
                "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                "__GL_SYNC_TO_VBLANK,0"
                "__GL_THREADED_OPTIMIZATIONS,0"
              ];
            };
          };
        };
    };
  };
}
