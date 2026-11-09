{ config, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager nixos;
  lanInterface = "enp3s0";
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
        externalDisk
        flaresolverr
        flood
        gitolite
        homeAssistant
        homepage
        immich
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

      security.sudo.wheelNeedsPassword = false;

      externalDisk.device = "/dev/disk/by-label/dock";

      environment.persistence."/persist".users.${settings.user}.directories = [ "dotfiles" ];

      programs.nh.flake = "${settings.home}/dotfiles";

      boot.initrd = {
        availableKernelModules = [ "r8169" ];
        systemd.network = {
          enable = true;
          networks."10-lan" = {
            matchConfig.Name = lanInterface;
            address = [ "${settings.lan.serverAddress}/24" ];
          };
        };
        network.ssh = {
          enable = true;
          port = settings.serverInitrdSshPort;
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
        "restic-restore-test-databases"
        "restic-restore-test-gitolite"
        "syncthing"
      ];

      systemd.network.links."40-${lanInterface}" = {
        matchConfig.OriginalName = lanInterface;
        linkConfig.WakeOnLan = "magic";
      };

      home-manager.users.${settings.user}.imports = with homeManager; [
        base
        bat
        carapace
        btop
        fd
        git
        gitolite
        nushell
        ripgrep
        starship
        tmux
        yazi
        zoxide
      ];
    };
}
