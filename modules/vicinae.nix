_: {
  modules.homeManager.workstation.vicinae = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
