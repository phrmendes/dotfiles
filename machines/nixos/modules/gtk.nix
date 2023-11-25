{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha";
      package = pkgs.catppuccin-gtk.override {
        accents = ["rosewater"];
        size = "compact";
        tweaks = ["rimless"];
        variant = "mocha";
      };
    };
  };
}
