{ config, ... }:
let
  serverAddress = config.const.lan.serverAddress;
in
{
  flake.modules.nixos.pikvm =
    { pkgs, ... }:
    let
      package = pkgs.local.pikvm;
      share = "${package}/share/kvmd";
      yaml = pkgs.formats.yaml { };
      mainConfig = yaml.generate "kvmd-main.yaml" {
        kvmd = {
          auth = {
            internal = {
              type = "htpasswd";
              file = "/var/lib/kvmd/htpasswd";
            };
            totp.secret.file = "";
          };
          hid.type = "otg";
          atx.type = "disabled";
          msd.type = "disabled";
          log_reader.enabled = false;
          info = {
            extras = "${pkgs.emptyDirectory}";
            hw = {
              vcgencmd_cmd = [ ];
              platform = "${pkgs.writeText "kvmd-platform" ''
                PIKVM_MODEL=DIY
                PIKVM_VIDEO=USB HDMI capture
                PIKVM_BOARD=NixOS
              ''}";
            };
          };
          streamer = {
            quality = 0;
            resolution = {
              default = "1920x1080";
              available = [
                "1920x1080"
                "1280x720"
                "640x480"
              ];
            };
            cmd = [
              "${pkgs.ustreamer}/bin/ustreamer"
              "--device=/dev/kvmd-video"
              "--persistent"
              "--format=mjpeg"
              "--resolution={resolution}"
              "--desired-fps={desired_fps}"
              "--unix={unix}"
              "--unix-rm"
              "--unix-mode=0660"
              "--exit-on-parent-death"
              "--process-name-prefix={process_name_prefix}"
              "--notify-parent"
              "--no-log-colors"
            ];
          };
        };
        nginx.https.enabled = false;
      };
    in
    {
      boot.kernelModules = [
        "libcomposite"
        "usb_f_hid"
        "uvcvideo"
      ];

      users.groups.kvmd = { };
      users.users.kvmd = {
        isSystemUser = true;
        group = "kvmd";
        extraGroups = [ "video" ];
      };
      users.users.nginx.extraGroups = [ "kvmd" ];

      environment.systemPackages = [ package ];
      environment.etc = {
        "kvmd/main.yaml".source = mainConfig;
        "kvmd/override.yaml".text = "{}";
        "kvmd/override.d".source = pkgs.emptyDirectory;
        "kvmd/meta.yaml".source = yaml.generate "kvmd-meta.yaml" { server.host = "@auto"; };
        "kvmd/web.css".text = "";
        "kvmd/nginx".source = "${share}/configs.default/nginx";
      };

      systemd.tmpfiles.rules = [
        "d /run/kvmd 0750 kvmd kvmd -"
        "d /var/lib/kvmd 0700 kvmd kvmd -"
        "f /var/lib/kvmd/htpasswd 0600 kvmd kvmd -"
      ];

      services.dbus.enable = true;
      services.udev.extraRules = ''
        SUBSYSTEM=="video4linux", KERNEL=="video0", ATTR{index}=="0", GROUP="kvmd", MODE="0660", SYMLINK+="kvmd-video"
        SUBSYSTEM=="hidg", KERNEL=="hidg0", GROUP="kvmd", MODE="0660", SYMLINK+="kvmd-hid-keyboard"
        SUBSYSTEM=="hidg", KERNEL=="hidg1", GROUP="kvmd", MODE="0660", SYMLINK+="kvmd-hid-mouse"
        SUBSYSTEM=="hidg", KERNEL=="hidg2", GROUP="kvmd", MODE="0660", SYMLINK+="kvmd-hid-mouse-alt"
      '';

      systemd.services.kvmd-otg = {
        description = "PiKVM USB keyboard and mouse";
        wantedBy = [ "multi-user.target" ];
        after = [
          "systemd-modules-load.service"
          "systemd-tmpfiles-setup.service"
          "sys-kernel-config.mount"
        ];
        requires = [ "sys-kernel-config.mount" ];
        restartTriggers = [ mainConfig ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${package}/bin/kvmd-otg start";
          ExecStop = "${package}/bin/kvmd-otg stop";
        };
      };

      systemd.services.kvmd = {
        description = "PiKVM web API";
        wantedBy = [ "multi-user.target" ];
        requires = [ "kvmd-otg.service" ];
        after = [
          "kvmd-otg.service"
          "dbus.service"
        ];
        restartTriggers = [ mainConfig ];
        serviceConfig = {
          User = "kvmd";
          Group = "kvmd";
          ExecStart = "${package}/bin/kvmd --run";
          Restart = "on-failure";
          RestartSec = 3;
          UMask = "0077";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nginx = {
        enable = true;
        appendHttpConfig = "include ${share}/configs.default/nginx/kvmd.ctx-http.conf;";
        virtualHosts."_" = {
          default = true;
          extraConfig = ''
            allow ${serverAddress};
            allow 127.0.0.1;
            allow ::1;
            deny all;
            include ${share}/configs.default/nginx/kvmd.ctx-server.conf;
          '';
        };
      };
      systemd.services.nginx.after = [ "kvmd.service" ];
    };
}
