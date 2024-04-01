{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira
      fira-code-nerdfont
      noto-fonts-color-emoji
    ];
  };
}
