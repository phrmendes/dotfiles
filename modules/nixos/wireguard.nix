{
  flake.modules.nixos.wireguard =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      secret = "wg.${config.networking.hostName}.conf";
    in
    {
      options.wireguard.configFile = lib.mkOption {
        type = lib.types.path;
        description = "Encrypted wg-quick configuration of this machine.";
      };

      config = {
        age.secrets.${secret} = config.utils.mkSecretReadable {
          file = config.wireguard.configFile;
        };

        environment.systemPackages = [
          (pkgs.writers.writeNuBin "vpn" (builtins.readFile ../../files/scripts/vpn.nu))
        ];

        networking.wg-quick.interfaces.home = {
          configFile = config.age.secrets.${secret}.path;
          autostart = false;
        };
      };
    };
}
