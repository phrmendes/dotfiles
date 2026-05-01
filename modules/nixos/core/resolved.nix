_: {
  modules.nixos.core.resolved = {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "false";
        LLMNR = "false";
      };
    };
  };
}
