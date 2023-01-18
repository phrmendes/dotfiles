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
          sd
          tealdeer
          shellcheck
          ranger
          stow
          exa
          python3Full
          poetry
          cargo
          go
          nodejs
          podman
          neovim
          terraform
          terragrunt
          tflint
          qemu
          tectonic
          git
        ];
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "lunarvim";
      };
    };
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      bat = {
        enable = true;
        config.theme = "Nord";
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
