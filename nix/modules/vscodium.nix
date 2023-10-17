{pkgs, ...}: let
  quarto.quarto = {
    name = "quarto";
    publisher = "quarto";
    version = "1.103.0";
    sha256 = "T4n8y/Fmy2RFZiLn93S7mrkaOSkw8J8OvuzSZhjUAjM=";
  };
  rxliuli.joplin = {
    name = "joplin-vscode-plugin";
    publisher = "rxliuli";
    version = "1.3.0";
    sha256 = "GB3jPHKyGVXupX94ts8w3Xq9I1WmkGOrCuKWdbsYjQc=";
  };
  goessner.mdmath = {
    name = "mdmath";
    publisher = "goessner";
    version = "2.7.4";
    sha256 = "DCh6SG7nckDxWLQvHZzkg3fH0V0KFzmryzSB7XTCj6s=";
  };
  mblode.zotero = {
    name = "zotero";
    publisher = "mblode";
    version = "0.1.10";
    sha256 = "XwlvVJ0gMR/rN3lgZchUUhB4mVk7X6ucfaSafnLClFE=";
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
        bierner.markdown-mermaid
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        davidanson.vscode-markdownlint
        oderwat.indent-rainbow
        tomoki1207.pdf
        valentjn.vscode-ltex
        vscodevim.vim
        yzhang.markdown-all-in-one
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        quarto.quarto
        rxliuli.joplin
        goessner.mdmath
        mblode.zotero
      ];
  };
}
