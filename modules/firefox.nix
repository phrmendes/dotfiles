_: {
  modules.homeManager.workstation.firefox = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };

    stylix.targets.firefox.profileNames = [ "default" ];
  };
}
