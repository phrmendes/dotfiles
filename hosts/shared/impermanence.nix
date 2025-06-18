{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc"
      "/run"
      "/var/db"
      "/var/lib"
      "/var/log"
    ];
  };
}
