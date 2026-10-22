{ config, ... }:
let
  inherit (config) settings;
  inherit (config.flake.modules) homeManager nixos;
in
{
  flake.modules.nixos.server = {
    imports = with nixos; [
      adguardhome
      atuin
      authelia
      bazarr
      beszel
      caddy
      core
      disko
      excalidraw
      flaresolverr
      flood
      gitolite
      homeAssistant
      homepage
      immich
      impermanence
      jellyfin
      linkding
      miniflux
      networking
      podman
      podmanServer
      postgresql
      prowlarr
      radarr
      restic
      searxng
      sftpgo
      sonarr
      storage
      sunshineProxy
      syncthingServer
    ];

    programs.nh.flake = "${settings.home}/dotfiles";

    boot.initrd = {
      systemd.network = {
        enable = true;
        networks."10-lan" = {
          matchConfig.Name = settings.lan.interface;
          address = [ "${settings.lan.serverAddress}/24" ];
        };
      };
      network.ssh = {
        enable = true;
        port = 2222;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        authorizedKeys = map builtins.readFile [
          ../../../files/ssh/main.txt
          ../../../files/ssh/laptop.txt
          ../../../files/ssh/phone.txt
        ];
      };
    };

    system.autoUpgrade = {
      enable = true;
      flake = "github:phrmendes/dotfiles#server";
      dates = "06:00,18:00";
      randomizedDelaySec = "5m";
      persistent = true;
    };

    systemd.network.links."40-${settings.lan.interface}" = {
      matchConfig.OriginalName = settings.lan.interface;
      linkConfig.WakeOnLan = "magic";
    };

    home-manager.users.${settings.user}.imports = with homeManager; [
      base
      bat
      btop
      fd
      fzf
      git
      gitolite
      jq
      nushell
      ripgrep
      tmux
      yazi
      zoxide
    ];
  };
}
