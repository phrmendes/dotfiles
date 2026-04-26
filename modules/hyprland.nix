_: {
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
          localPackages,
          ...
        }:
        let
          inherit (lib) getExe;
          isLaptop = osConfig.machine.type == "laptop";
          inherit (osConfig.machine) monitors;
          hyprlock = getExe pkgs.hyprlock;
          playerctl = getExe pkgs.playerctl;
          vicinae = getExe pkgs.vicinae;
          swayosd = "${pkgs.swayosd}/bin/swayosd-client";
          screenshot = getExe localPackages.screenshot;
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
                gaps_out = 6;
                border_size = 2;
                layout = "dwindle";
                resize_on_border = true;
              };
              decoration = {
                active_opacity = 1;
                inactive_opacity = 0.9;
                rounding = 10;
                blur.enabled = false;
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
                ",XF86AudioRaiseVolume,exec,${swayosd} --output-volume raise --max-volume 150"
                ",XF86AudioLowerVolume,exec,${swayosd} --output-volume lower"
                ",XF86AudioMute,exec,${swayosd} --output-volume mute-toggle"
                ",XF86AudioMicMute,exec,${swayosd} --input-volume mute-toggle"
                (lib.mkIf isLaptop ",XF86MonBrightnessUp,exec,${swayosd} --brightness raise")
                (lib.mkIf isLaptop ",XF86MonBrightnessDown,exec,${swayosd} --brightness lower")
                "SUPER ALT,h,resizeactive,-20 0"
                "SUPER ALT,j,resizeactive,0 20"
                "SUPER ALT,k,resizeactive,0 -20"
                "SUPER ALT,l,resizeactive,20 0"
              ];
              bind = [
                "CTRL ALT,L,exec,${hyprlock}"
                ",print,exec,${screenshot}"
                "SUPER,space,exec,${vicinae} toggle"
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

      hypridle =
        {
          pkgs,
          lib,
          osConfig,
          ...
        }:
        let
          isLaptop = osConfig.machine.type == "laptop";
          hyprlock = lib.getExe pkgs.hyprlock;
          hyprctl = "${pkgs.hyprland}/bin/hyprctl";
          brightnessctl = lib.getExe pkgs.brightnessctl;
          lock_cmd = "pidof ${hyprlock} || ${hyprlock}";
        in
        {
          services.hypridle = {
            enable = true;
            settings = {
              general = {
                before_sleep_cmd = lock_cmd;
                after_sleep_cmd = "${hyprctl} dispatch dpms on";
                ignore_dbus_inhibit = false;
                inherit lock_cmd;
              };

              listener = [
                (lib.mkIf isLaptop {
                  timeout = 290;
                  on-timeout = "${brightnessctl} set 10%";
                  on-resume = "${brightnessctl} --restore ";
                })
                {
                  timeout = 300;
                  on-timeout = "${lock_cmd}";
                }
                {
                  timeout = 330;
                  on-timeout = "${hyprctl} dispatch dpms off";
                  on-resume = "${hyprctl} dispatch dpms on";
                }
              ];
            };
          };
        };

      hyprlock = {
        programs.hyprlock.enable = true;
      };

      hyprpaper =
        { lib, ... }:
        {
          services.hyprpaper = {
            enable = true;
            settings.splash = false;
          };

          systemd.user.services.hyprpaper.Service.RestartSec = lib.mkForce "2";
        };
    };
  };
}
