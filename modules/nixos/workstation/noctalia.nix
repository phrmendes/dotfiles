{ inputs, ... }:
{
  modules.nixos.workstation.noctalia =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      services = {
        power-profiles-daemon.enable = lib.mkDefault true;
        upower.enable = true;
      };
    };
}
