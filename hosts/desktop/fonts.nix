{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira
      fira-code-nerdfont
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["FiraCode Nerd Font Mono"];
      sansSerif = ["Fira Sans"];
      serif = ["Fira Sans"];
    };
  };
}
