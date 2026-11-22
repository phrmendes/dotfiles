{ inputs, ... }:
{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      neovimNightly = inputs.neovim-nightly;
      dotfilesDir = osConfig.workstation.dotfilesDir or "${config.home.homeDirectory}/.config/dotfiles";
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      programs.neovim = {
        enable = true;
        package = neovimNightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = false;
        extraPackages = with pkgs; [
          bash-language-server
          docker-language-server
          kdlfmt
          ltex-ls-plus
          lua-language-server
          marksman
          nixd
          nixfmt
          nu-lint
          nufmt
          prettier
          shellcheck
          shellharden
          shfmt
          stylua
          tree-sitter
          vscode-langservers-extracted
          yaml-language-server
        ];
      };

      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

      home = {
        packages = lib.mkIf (osConfig ? workstation) [ pkgs.neovim-gtk ];
        file = {
          ".config/nvim".source = mkOutOfStoreSymlink "${dotfilesDir}/files/neovim/config";
          ".local/share/nvim/site/pack/external/start" = lib.mkIf (osConfig ? externalDisk) {
            source = mkOutOfStoreSymlink "/mnt/external/projects/neovim";
          };
        };
      };

      xdg.desktopEntries = lib.mkIf (osConfig ? workstation) {
        "org.daa.NeovimGtk" = {
          name = "Neovim";
          genericName = "Text Editor";
          exec = "${pkgs.neovim-gtk}/bin/nvim-gtk %F";
          icon = "org.daa.NeovimGtk";
          categories = [
            "Utility"
            "TextEditor"
          ];
        };
      };
    };
}
