{
  home.file = {
    ".local/share/mc/skins/catppuccin.ini".source = ../../dotfiles/mc/skin/catppuccin.ini;
    ".config/mc".source = ../../dotfiles/mc;
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
