{
  flake.modules.nixos.angrr = {
    services.angrr = {
      enable = true;
      timer.enable = true;
      settings.temporary-root-policies = {
        direnv = {
          path-regex = "/\\.direnv/";
          period = "7d";
        };
        devenv = {
          path-regex = "/\\.devenv/";
          period = "7d";
        };
        result = {
          path-regex = "/result[^/]*$";
          period = "6h";
        };
      };
    };
  };
}
