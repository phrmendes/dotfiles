{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Yellow-Normal";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        size = "standard";
        accents = ["yellow"];
        tweaks = ["normal"];
      };
    };
  };
}
