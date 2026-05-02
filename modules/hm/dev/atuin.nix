_: {
  modules.homeManager.dev.atuin = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        sync_address = "https://atuin.local.ohlongjohnson.tech";
        ai = {
          enabled = true;
          endpoint = "https://litellm.local.ohlongjohnson.tech";
        };
      };
    };
  };
}
