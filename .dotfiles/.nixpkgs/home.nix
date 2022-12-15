{ config, pkgs, ... }:

let
  user = "prochame";
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/Users/${user}";
      packages = with pkgs;
        [
          pandoc
          bat
          lazygit
          ripgrep
          fd
          sd
          tealdeer
          exa
          shellcheck
          direnv
          ranger
          stow
          python311
          cargo
          go
          nodejs
          podman
          neovim
          texlive.combined.scheme-minimal
        ];
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "lunarvim";
      };
    };
    programs = {
      git = {
        enable = true;
        userName = "Pedro Mendes";
        userEmail = "phrmendes@tuta.io";
      };
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
      fish = {
        enable = true;
        shellAliases = {
          mkdir = "mkdir -p";
          ls = "exa --icons";
          cat = "bat";
          nv = "nvim";
          lg = "lazygit";
        };
        shellAbbrs = {
          stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
        };
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
