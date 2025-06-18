{ pkgs, ... }:
{
  systemd.services.docker-compose = {
    description = "Docker Compose Service";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/etc/compose";
      ExecStart = "${pkgs.docker}/bin/docker compose up --detach --remove-orphans";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      Restart = "always";
      RemainAfterExit = true;
    };
  };
}
