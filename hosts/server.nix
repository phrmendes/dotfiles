{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.server.module =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.mosh
        nixos.server
      ];

      networking.hostName = "server";

      boot.initrd.availableKernelModules = [ "r8169" ];

      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
      hardware.cpu.intel.updateMicrocode = true;

      hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.intel-media-driver ];
      };
    };
}
