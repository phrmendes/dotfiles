_: {
  modules.nixos.server.duplicati =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      port = 8200;
      domain = config.server.caddy.domain;
      dupNotify = pkgs.writeShellApplication {
        name = "dup-notify";
        runtimeInputs = [ pkgs.local.telegram-notify ];
        checkPhase = "";
        text = ''
          case "''${DUPLICATI__PARSED_RESULT:-Unknown}" in
            Warning)
              telegram-notify warn \
                "Backup warning: ''${DUPLICATI__backup_name}" \
                "<pre>finished with status: Warning</pre>"
              ;;
            Error|Fatal)
              telegram-notify error \
                "Backup failed: ''${DUPLICATI__backup_name}" \
                "<pre>finished with status: ''${DUPLICATI__PARSED_RESULT}</pre>"
              ;;
            *)
              exit 0
              ;;
          esac
        '';
      };
      parametersFile = pkgs.writeText "duplicati-parameters" ''
        --run-script-after=${lib.getExe dupNotify}
        --webservice-allowed-hostnames=duplicati.${domain}
      '';
      startScript = pkgs.writeShellScript "duplicati-start" ''
        exec ${lib.getExe' pkgs.duplicati "duplicati-server"} \
          --webservice-interface=127.0.0.1 \
          --webservice-port=${toString port} \
          --server-datafolder=${config.services.duplicati.dataDir} \
          --parameters-file=${parametersFile} \
          --webservice-password="$DUPLICATI_PASSWORD"
      '';
    in
    {
      server.homepage.services.duplicati = {
        dataDir = config.services.duplicati.dataDir;
        url = "duplicati.${domain}";
        monitoredServices = [ "duplicati" ];
        homepage = {
          name = "Duplicati";
          description = "Backup client";
          icon = "sh-duplicati";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "duplicati" port;

      systemd.tmpfiles.rules = [ "d /srv/duplicati 0750 root root -" ];

      systemd.services.duplicati.serviceConfig = {
        EnvironmentFile = [
          config.age.secrets."telegram.env".path
          config.age.secrets."duplicati.env".path
        ];
        ExecStart = lib.mkForce startScript;
      };

      services.duplicati = {
        enable = true;
        inherit port;
        dataDir = "/srv/duplicati";
        interface = "127.0.0.1";
        user = "root";
      };
    };
}
