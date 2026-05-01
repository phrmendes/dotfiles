{ pkgs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp-token = pkgs.callPackage ./gcp-token.nix { };
  hx-tmux-send = pkgs.callPackage ./hx-tmux-send.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  t = pkgs.callPackage ./t.nix { };
}
