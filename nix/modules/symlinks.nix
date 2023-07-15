{
  home.file = {
    ".config/nix/nix.conf".source = ../cfg/nix.conf;
    ".config/nixpkgs/config.nix".source = ../cfg/config.nix;
    ".config/lf/lfrc".source = ../cfg/lfrc;
    ".default-python-packages".source = ../cfg/default-python-packages.txt;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/efm-langserver/config.yaml".source = ../cfg/efm.yaml;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
