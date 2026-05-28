{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.server.module =
    {
      config,
      lib,
      ...
    }:
    {
      imports =
        builtins.attrValues nixos.core
        ++ (with nixos.server; [
          adguardhome
          age
          atuin
          automation
          beszel
          caddy
          duplicati
          excalidraw
          filesystems
          flaresolverr
          homepage
          bifrost
          linkding
          litestream
          media
          neovim
          networking
          persistence
          podman
          qbittorrent
          options
          sftpgo
          syncthing
          tailscale
        ]);

      networking.hostName = "server";
      machine.dotfilesDir = "${settings.home}/dotfiles";
      programs.nh.flake = "${settings.home}/dotfiles";
      machine.type = "server";
      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      home-manager.users.${settings.user}.imports =
        (with homeManager.user; [
          base
        ])
        ++ (with homeManager.dev; [
          bat
          btop
          fd
          fzf
          git
          jq
          packages
          ripgrep
          yazi
          zoxide
          zsh
        ]);
    };
}
