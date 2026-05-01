_: {
  modules.nixos.workstation.ly = {
    environment.binsh = "/run/current-system/sw/bin/bash";
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        margin_box_h = 4;
        input_len = 44;
        edge_margin = 2;
        bigclock = "en";
        text_in_center = true;
      };
    };
  };
}
