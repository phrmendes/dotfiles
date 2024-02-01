{
  home.file = {
    ".config/kitty/get_layout.py".source = ../../dotfiles/kitty/get_layout.py;
    ".config/kitty/pass_keys.py".source = ../../dotfiles/kitty/pass_keys.py;
    ".local/share/mc/skins/catppuccin.ini".source = ../../dotfiles/mc/skin/catppuccin.ini;
    ".config/mc".source = ../../dotfiles/mc;
    ".config/zellij".source = ../../dotfiles/zellij;
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
