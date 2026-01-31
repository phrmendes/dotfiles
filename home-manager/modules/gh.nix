{ config, lib, ... }:
{
  options.gh.enable = lib.mkEnableOption "enable gh";

  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    programs.gh-dash = {
      enable = true;
      settings = {
        prSections = [
          {
            title = "All PRs";
            filters = "is:pr is:open";
          }
          {
            title = "My PRs";
            filters = "is:pr is:open author:@me";
          }
          {
            title = "Needs My Review";
            filters = "is:pr is:open review-requested:@me";
          }
          {
            title = "My Involved PRs";
            filters = "is:pr is:open involves:@me";
          }
        ];
      };
    };
  };
}
