{ inputs, ... }:
{
  modules.nixos.core.impermanence = {
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc"
        "/var/db"
        "/var/lib"
        "/var/log"
      ];
    };
  };
}
