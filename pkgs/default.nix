{ pkgs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp-token = pkgs.callPackage ./gcp-token.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nvim-treesitter = pkgs.callPackage ./nvim-treesitter.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  server = import ./server { inherit pkgs; };
  vim-remote = pkgs.callPackage ./vim-remote.nix { };
}
