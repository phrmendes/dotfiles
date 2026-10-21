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
    {
      imports = with nixos; [
        authelia
        core
        disko
        storage
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
        podmanServer
        postgresql
        sftpgo
        syncthing
      ];

      networking.hostName = "server";

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

      systemd = {
        network.links."40-${settings.lan.interface}" = {
          matchConfig.OriginalName = settings.lan.interface;
          linkConfig.WakeOnLan = "magic";
        };

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
