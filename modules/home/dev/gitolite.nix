{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.gitolite = {
    programs.ssh.settings.gitolite = {
      HostName = settings.lan.serverAddress;
      User = "gitolite";
    };
  };
}
