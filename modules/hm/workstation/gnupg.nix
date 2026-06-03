{
  modules.homeManager.workstation.gnupg = _: {
    programs.gpg = {
      enable = true;
      settings = {
        use-agent = true;
        no-symkey-cache = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = false;
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
    };
  };
}
