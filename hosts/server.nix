{ config, ... }:
let
  inherit (config) nixosModules settings homeModules;
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
      inherit (config.dotfilesLib) mkSecretReadable;
    in
    {
      imports = with nixosModules; [
        dotfilesLib
        authelia
        core
        disko
        adguardhome
        atuin
        beszel
        caddy
        restic
        excalidraw
        grafito
        homeAssistant
        homepage
        immich
        impermanence
        linkding
        litestream
        media
        networking
        options
        podman
        sftpgo
        syncthing
        tailscale
        transmission
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
        "caddy.env" = mkSecretReadable { file = ../secrets/caddy.age.env; };
        "grafito.env" = mkSecretReadable { file = ../secrets/grafito.age.env; };
        "linkding.env" = mkSecretReadable { file = ../secrets/linkding.age.env; };
        "litestream.env" = mkSecretReadable { file = ../secrets/litestream.age.env; };
        "restic.env" = mkSecretReadable { file = ../secrets/restic.age.env; };
        "sftpgo.env" = mkSecretReadable {
          file = ../secrets/sftpgo.age.env;
          owner = "sftpgo";
        };
        "dockerhub.json" = mkSecretReadable {
          file = ../secrets/dockerhub.age.json;
          path = "/root/.docker/config.json";
        };
      };

      networking.hostName = "server";
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

      system.autoUpgrade = {
        enable = true;
        flake = "github:phrmendes/dotfiles#server";
        dates = "06:00,18:00";
        randomizedDelaySec = "5m";
        persistent = true;
      };

      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/external";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /run/sync 0700 ${settings.user} users -"
        "d /mnt/external 2775 ${settings.user} external -"
        "a+ /mnt/external - - - - d:g:external:rwx,g:external:rwx,d:group::rwx,group::rwx,d:mask::rwx,mask::rwx"
        "d /mnt/external/books 2775 ${settings.user} external -"
        "d /mnt/external/zotero 2775 ${settings.user} external -"
        "d /srv 0755 root root -"
        "d /srv/containers 0755 root root -"
      ];

      systemd.services = {
        fake-hwclock-restore = {
          description = "Restore system clock from disk";
          wantedBy = [ "sysinit.target" ];
          after = [ "local-fs.target" ];
          before = [ "time-sync.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          path = [ pkgs.coreutils ];
          script = ''
            if [ -f /var/lib/fake-hwclock ]; then
              date -s @$(cat /var/lib/fake-hwclock)
            fi
          '';
        };

        fake-hwclock-save = {
          description = "Save system clock to disk";
          wantedBy = [ "shutdown.target" ];
          before = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          path = [ pkgs.coreutils ];
          script = ''
            date +%s > /var/lib/fake-hwclock
          '';
        };
      };

      home-manager.users.${settings.user}.imports = with homeModules; [
        base
        bat
        btop
        eza
        fd
        fzf
        git
        jq
        ripgrep
        starship
        tealdeer
        yazi
        tmux
        zoxide
        zsh
      ];
    };
}
