{
  home.file = {
    ".amethyst.yml".source = ../../shared/dotfiles/amethyst.yml;
    ".wezterm.lua".source = ../../shared/dotfiles/wezterm.lua;
    ".config/nvim" = {
      source = ../../shared/dotfiles/nvim;
      recursive = true;
    };
  };
}
