{
  home.file = {
    ".amethyst.yml".source = ../../../dotfiles/amethyst.yml;
    ".wezterm.lua".source = ../../../dotfiles/wezterm.lua;
    ".config/nvim" = {
      source = ../../../dotfiles/nvim;
      recursive = true;
    };
  };
}
