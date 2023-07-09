{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Yellow-Rimless";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        size = "compact";
        accents = ["yellow"];
        tweaks = ["rimless"];
      };
    };
  };
}
