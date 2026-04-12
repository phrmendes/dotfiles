{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.server.module =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports =
        (with nixos.core; [
          age
          boot
          disko
          filesystems
          hardware
          home-manager
          i18n
          impermanence
          networking
          nix-settings
          nixpkgs
          options
          programs
          security
          services
          stylix
          swap
          system-packages
          users
          virtualisation
        ])
        ++ (with nixos.server; [
          automation
          filesystems
          persistence
          secrets
          tailscale
        ]);

      networking.hostName = "server";
      programs.nh.flake = "/home/${settings.user}/dotfiles";
      machine.type = "server";

      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      environment.systemPackages = with pkgs; [
        gh
        just
        neovim
        python313
      ];

      home-manager.users.${settings.user} = {
        imports =
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
            ripgrep
            zoxide
            zsh
          ]);

        xdg.configFile."nvim/init.lua".source = ../files/neovim.lua;
      };
    };
}
