{pkgs, ...}: {
  fonts = {
    fontsDir.enable = true;
    fonts = with pkgs; [
      fira
      fira-code-nerdfont
      noto-fonts-color-emoji
    ];
  };
}
