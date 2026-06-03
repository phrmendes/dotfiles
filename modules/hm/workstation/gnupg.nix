{
  modules.homeManager.workstation.gnupg = {
    programs.gpg = {
      enable = true;
      settings = {
        use-agent = true;
        no-symkey-cache = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
    };
  };
}
