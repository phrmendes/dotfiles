{
  home.file = {
    ".config/efm-langserver/config.yaml".source = ../cfg/efm.yaml;
    ".config/nix/nix.conf".source = ../cfg/nix.conf;
    ".local/bin/preview.sh".source = ../cfg/joshuto/preview.sh;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/helix" = {
      source = ../cfg/helix;
      recursive = true;
    };
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
