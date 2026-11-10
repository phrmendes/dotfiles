{
  flake.modules.nixos.angrr = {
    services.angrr = {
      enable = true;
      timer.enable = true;
      settings.temporary-root-policies = {
        direnv = {
          path-regex = "/\\.direnv/";
          period = "14d";
        };
        devenv = {
          path-regex = "/\\.devenv/";
          period = "14d";
        };
        result = {
          path-regex = "/result[^/]*$";
          period = "3d";
        };
      };
    };
  };
}
