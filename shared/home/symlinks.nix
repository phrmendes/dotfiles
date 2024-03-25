{
  home.file = {
    ".local/share/mc/skins/catppuccin.ini".source = ../../dotfiles/mc/skin/catppuccin.ini;
    ".config/kitty/neighboring_window.py".source = ../../dotfiles/kitty/neighboring_window.py;
    ".config/kitty/pass_keys.py".source = ../../dotfiles/kitty/pass_keys.py;
    ".config/kitty/relative_resize.py".source = ../../dotfiles/kitty/relative_resize.py;
    ".config/mc".source = ../../dotfiles/mc;
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
