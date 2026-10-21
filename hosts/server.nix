{ config, ... }:
let
  inherit (config) settings;
  inherit (config.flake.modules) homeManager nixos;
in
{
  configurations.nixos.server.module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.utils) mkSecretReadable;
    in
    {
      imports = with nixos; [
        authelia
        core
        disko
        adguardhome
        atuin
        beszel
        caddy
        restic
        searxng
        excalidraw
        flood
        gitolite
        homeAssistant
        homepage
        immich
        impermanence
        linkding
        miniflux
        media
        networking
        podman
        postgresql
        sftpgo
        syncthing
      ];

      age.secrets = {
        "users.yaml" = mkSecretReadable {
          file = ../secrets/users.age.yaml;
          owner = "authelia";
        };
        "authelia.yaml" = mkSecretReadable {
          file = ../secrets/authelia.age.yaml;
          owner = "authelia";
        };
        "beszel.env" = mkSecretReadable { file = ../secrets/beszel.age.env; };
        "ca.key" = mkSecretReadable {
          file = ../secrets/ca.age.key;
          owner = "caddy";
        };
        "linkding.env" = mkSecretReadable { file = ../secrets/linkding.age.env; };
        "miniflux.env" = mkSecretReadable {
          file = ../secrets/miniflux.age.env;
          owner = "miniflux";
        };
        "restic.env" = mkSecretReadable { file = ../secrets/restic.age.env; };
        "sftpgo.env" = mkSecretReadable {
          file = ../secrets/sftpgo.age.env;
          owner = "sftpgo";
        };
        "searxng.env" = mkSecretReadable {
          file = ../secrets/searxng.age.env;
          owner = "searx";
        };
        "dockerhub.json" = mkSecretReadable {
          file = ../secrets/dockerhub.age.json;
          path = "/root/.docker/config.json";
        };
      };

      networking.hostName = "server";

      services.restic.backups = {
        zotero = config.restic.mkBackup "zotero" { paths = [ "/mnt/external/zotero" ]; };
        books = config.restic.mkBackup "books" { paths = [ "/mnt/external/books" ]; };
      };

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

      programs.nh.flake = "${settings.home}/dotfiles";
      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.intel-media-driver ];
      };

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      virtualisation = {
        oci-containers.backend = "podman";
        podman.autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--all" ];
        };
      };

      system.autoUpgrade = {
        enable = true;
        flake = "github:phrmendes/dotfiles#server";
        dates = "06:00,18:00";
        randomizedDelaySec = "5m";
        persistent = true;
      };

      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/dock";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      systemd = {
        network.links."40-${settings.lan.interface}" = {
          matchConfig.OriginalName = settings.lan.interface;
          linkConfig.WakeOnLan = "magic";
        };

        tmpfiles.rules = [
          "d /run/sync 0700 ${settings.user} users -"
          "d /mnt/external 2775 ${settings.user} external -"
          "a+ /mnt/external - - - - d:g:external:rwx,g:external:rwx,d:group::rwx,group::rwx,d:mask::rwx,mask::rwx"
          "d /mnt/external/books 2775 ${settings.user} external -"
          "d /mnt/external/zotero 2775 ${settings.user} external -"
        ];

        services.podman-network-services = {
          description = "Create Podman services network";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.podman ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            if ! podman network exists services; then
              podman network create --subnet ${settings.podmanSubnet} services
            fi
          '';
        };

        timers.podman-auto-update = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "1h";
          };
        };
      };

      home-manager.users.${settings.user}.imports = with homeManager; [
        base
        bat
        btop
        fd
        fzf
        git
        jq
        nushell
        ripgrep
        tmux
        yazi
        zoxide
      ];
    };
}
