{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.gitolite =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.services.gitolite) dataDir user group;
      owner = "phrmendes";
      repos = [
        "academic-templates"
        "bib.nvim"
        "dotfiles"
        "notes.nvim"
        "pi-plan-mode"
        "thesis"
        "todotxt.nvim"
      ];
      backupRepos = pkgs.writers.writeNuBin "backup-repos" (
        builtins.readFile ../../files/scripts/backup-repos.nu
      );
    in
    {
      services.gitolite = {
        enable = true;
        adminPubkey = builtins.readFile ../../files/ssh/main.txt;
      };

      services.restic.backups.gitolite = config.restic.mkBackup "gitolite" {
        paths = [ dataDir ];
        backupPrepareCommand = "${config.systemd.package}/bin/systemctl start gitolite-mirror.service || true";
      };

      systemd = {
        services.gitolite-mirror = {
          description = "Mirror the GitHub repositories into gitolite";
          after = [
            "gitolite-init.service"
            "network-online.target"
          ];
          requires = [ "gitolite-init.service" ];
          wants = [ "network-online.target" ];
          path = with pkgs; [
            git
            gitolite
            openssh
            perl
          ];
          environment.NU_LOG_FORMAT = "%LEVEL% %MSG%";
          serviceConfig = {
            Type = "oneshot";
            User = user;
            Group = group;
            WorkingDirectory = dataDir;
            ExecStopPost = "${lib.getExe pkgs.gitolite} setup";
            ExecStart = "${lib.getExe backupRepos} ${
              lib.escapeShellArgs (
                [
                  "${dataDir}/repositories"
                  owner
                ]
                ++ repos
              )
            }";
          };
        };
      };
    };
  flake.modules.homeManager.gitolite = _: {
    programs.ssh.settings.gitolite = {
      HostName = settings.lan.serverAddress;
      User = "gitolite";
    };
  };
}
