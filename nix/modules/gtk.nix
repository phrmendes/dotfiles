{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Yellow-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        size = "standard";
        accents = ["yellow"];
        tweaks = ["normal"];
      };
    };
  };
}
