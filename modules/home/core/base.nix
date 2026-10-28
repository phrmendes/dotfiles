{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.homeManager.base =
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
            HostName = settings.lan.serverAddress;
            User = settings.user;
          };
          "desktop" = {
            HostName = settings.lan.desktopAddress;
            User = settings.user;
            ProxyJump = "server";
          };
          "laptop" = {
            HostName = "laptop.${settings.serverDomain}";
            User = settings.user;
            ConnectTimeout = 5;
          };
          "server-unlock" = {
            HostName = settings.lan.serverAddress;
            Port = 2222;
            User = "root";
            HostKeyAlias = "server-initrd";
            RequestTTY = "yes";
            RemoteCommand = "systemd-tty-ask-password-agent --query";
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
          QT_QPA_PLATFORM = "wayland";
          SUDO_EDITOR = editor;
          VISUAL = editor;
        };
      };
    };
}
