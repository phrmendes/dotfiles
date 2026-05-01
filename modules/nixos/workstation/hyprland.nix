_: {
  modules.nixos.workstation.hyprland = {
    programs = {
      dconf.enable = true;
      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };
}
