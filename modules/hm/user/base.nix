{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.homeManager.user.base =
    { lib, ... }:
    let
      editor = lib.mkOverride 1001 "nvim";
    in
    {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*".AddKeysToAgent = "no";
          "server" = {
            HostName = "server.codlet-catfish.ts.net";
            User = settings.user;
          };
          "server-local" = {
            HostName = settings.lan.serverAddress;
            User = settings.user;
          };
        };
      };

      home = {
        inherit (settings) stateVersion;
        username = settings.user;
        homeDirectory = settings.home;
        sessionVariables = {
          COLORTERM = "truecolor";
          EDITOR = editor;
          GIT_EDITOR = editor;
          SUDO_EDITOR = editor;
          VISUAL = editor;
        };
      };
    };
}
