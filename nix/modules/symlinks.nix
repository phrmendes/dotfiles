{
  home.file = {
    ".local/bin/preview.sh".source = ../cfg/joshuto/preview.sh;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/nix/nix.conf".source = ../cfg/nix.conf;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
