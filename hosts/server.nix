{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
  coreImports = import ./imports.nix { inherit nixos; };
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
        coreImports
        ++ (with nixos.server; [
          automation
          container
          filesystems
          litellm
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
            helix
            jq
            packages
            pi
            ripgrep
            zoxide
            zsh
          ]);
      };
    };
}
