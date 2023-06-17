{
  home.file = {
    ".config/nix/nix.conf".source = ../cfg/nix.conf;
    ".config/nixpkgs/config.nix".source = ../cfg/config.nix;
    ".default-python-packages".source = ../cfg/default-python-packages.txt;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
