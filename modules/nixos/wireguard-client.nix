{
  flake.modules.nixos.wireguardClient =
    { config, ... }:
    {
      age.secrets."wg-laptop.conf" = config.utils.mkSecretReadable {
        file = ../../secrets/wg-laptop.age.conf;
      };

      networking.wg-quick.interfaces.home = {
        configFile = config.age.secrets."wg-laptop.conf".path;
        autostart = false;
      };
    };
}
