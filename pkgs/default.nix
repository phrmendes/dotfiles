{ pkgs, stable }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  neovim = pkgs.callPackage ./neovim.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  telegram-notify = pkgs.callPackage ./telegram-notify.nix {
    apprise = stable.apprise;
  };
}
