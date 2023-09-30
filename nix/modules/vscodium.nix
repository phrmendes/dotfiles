{pkgs, ...}: let
  quarto.quarto = {
    name = "quarto";
    publisher = "quarto";
    version = "1.101.0";
    sha256 = "sha256-xMqukPfgdpry4SF4HbiOHAeof6J7LeTRlFfrN9zAzYI=";
  };
in {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    keybindings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/settings.json);
    extensions = with pkgs.vscode-extensions;
      [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        oderwat.indent-rainbow
        tomoki1207.pdf
        valentjn.vscode-ltex
        vscodevim.vim
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        quarto.quarto
      ];
  };
}
