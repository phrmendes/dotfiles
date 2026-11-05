{ config, ... }:
let
  inherit (config) settings;
  inherit (config.flake.modules) homeManager nixos;
in
{
  configurations.nixos.server.module =
    {
      pkgs,
      ...
    }:
    {
      imports = with nixos; [
        adguardhome
        atuin
        authelia
        bazarr
        beszel
        caddy
        calibre
        core
        ddclient
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
        kosync
        linkding
        miniflux
        mosh
        networking
        notify
        podman
        podmanServer
        postgresql
        prowlarr
        radarr
        restic
        searxng
        serverLogs
        sftpgo
        shelfmark
        sonarr
        storage
        sunshineProxy
        syncthingServer
      ];

      networking.hostName = "server";

      programs.nh.flake = "${settings.home}/dotfiles";

      boot.initrd = {
        availableKernelModules = [ "r8169" ];
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
            ../files/ssh/main.txt
            ../files/ssh/laptop.txt
            ../files/ssh/phone.txt
          ];
        };
      };

      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
      hardware.cpu.intel.updateMicrocode = true;

      hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.intel-media-driver ];
      };

      system.autoUpgrade = {
        enable = true;
        flake = "github:phrmendes/dotfiles#server";
        dates = "06:00,18:00";
        randomizedDelaySec = "5m";
        persistent = true;
      };

      notifyOnFailure = [
        "beszel-hub"
        "caddy"
        "check-external"
        "immich"
        "nixos-upgrade"
        "postgresql"
        "syncthing"
      ];

      systemd.network.links."40-${settings.lan.interface}" = {
        matchConfig.OriginalName = settings.lan.interface;
        linkConfig.WakeOnLan = "magic";
      };

      home-manager.users.${settings.user}.imports = with homeManager; [
        base
        bat
        btop
        fd
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
