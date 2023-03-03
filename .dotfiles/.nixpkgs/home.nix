{ config, pkgs, ... }:

let
  user = "prochame";
in
{
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/Users/${user}";
      packages = with pkgs.unstable;
        [
          # CLI apps
          podman
          qemu
          pandoc
          lazygit
          ripgrep
          fd
          sd
          gnupg
          stow
          exa
          sqlite
          jq
          tectonic
          tere
          imagemagick
          ispell
          aspell
          aspellDicts.pt_BR
          aspellDicts.en
          ansible
          gh
          git
          gnumake
          cmake
          gcc
          libgccjit
          zlib
          # terraform
          terraform
          tflint
          terragrunt
          # python
          python311
          python311Packages.ipython
          python311Packages.grip
          python311Packages.black
          python311Packages.pyflakes
          python311Packages.isort
          python311Packages.pytest
          python311Packages.nose
          pipenv
          # go
          go
          gopls
          gotests
          gore
          gotools
          gomodifytags
          delve
          # nix
          rnix-lsp
          nixfmt
          # shell script
          shfmt
          shellcheck
          # others
          cargo
          nodejs
        ];
      stateVersion = "22.11";
      sessionVariables = {
        VISUAL = "vim";
      };
    };
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      bat.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      helix = {
        enable = true;
        settings.theme = "base16_terminal";
      };
    };
  };
}
