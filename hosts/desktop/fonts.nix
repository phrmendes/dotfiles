{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      cantarell-fonts
      fira-code-nerdfont
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["FiraCode Nerd Font Mono"];
      sansSerif = ["Cantarell Regular"];
      serif = ["Cantarell Regular"];
    };
  };
}
