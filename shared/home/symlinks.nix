{
  home.file = {
    ".local/share/mc/skins/catppuccin.ini".source = ../../dotfiles/mc/skin/catppuccin.ini;
    ".config/kitty/scripts".source = ../../dotfiles/kitty/scripts;
    ".config/mc".source = ../../dotfiles/mc;
    ".config/zellij".source = ../../dotfiles/zellij;
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
