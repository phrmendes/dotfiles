{ pkgs }:
{
  btrfs-cleanup = pkgs.callPackage ./btrfs-cleanup.nix { };
  litellm = pkgs.callPackage ./litellm.nix { inherit (pkgs) litellm; };
  deploy = dotfiles: pkgs.callPackage ./deploy.nix { inherit dotfiles; };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp-token = pkgs.callPackage ./gcp-token.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nvim-remote = pkgs.callPackage ./nvim-remote.nix { };
  nvim-server = pkgs.callPackage ./nvim-server.nix { };
  nvim-treesitter = pkgs.callPackage ./nvim-treesitter.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  telegram-notify = pkgs.callPackage ./telegram-notify.nix { };
}
