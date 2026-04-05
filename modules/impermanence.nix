_: {
  modules.nixos.core.impermanence = {
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
