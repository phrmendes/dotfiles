{
  home.file = {
    ".config/nix/nix.conf".source = ../cfg/nix.conf;
    ".config/nixpkgs/config.nix".source = ../cfg/config.nix;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".profile".source = ../cfg/.profile;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
