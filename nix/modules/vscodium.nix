{pkgs, ...}: let
  quarto.quarto = {
    name = "quarto";
    publisher = "quarto";
    version = "1.97.0";
    sha256 = "naBQE9vZ9EhvwLQv9Q3TBLe25+It+2YD9kWxj+HgGwM=";
  };
  corker.micromamba = {
    name = "vscode-micromamba";
    publisher = "corker";
    version = "0.1.18";
    sha256 = "2lCr4+S/mYAC1b6hxwkuRbueFFoJDxo7L+CTvPmUnxk=";
  };
  sleistner.vscode-fileutils = {
    name = "vscode-fileutils";
    publisher = "sleistner";
    version = "3.10.3";
    sha256 = "v9oyoqqBcbFSOOyhPa4dUXjA2IVXlCTORs4nrFGSHzE=";
  };
in {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    keybindings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/settings.json);
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      charliermarsh.ruff
      kahole.magit
      ms-azuretools.vscode-docker
      ms-pyright.pyright
      ms-python.python
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      oderwat.indent-rainbow
      tomoki1207.pdf
      valentjn.vscode-ltex
      vscodevim.vim
      vspacecode.whichkey
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      quarto.quarto
      corker.micromamba
      sleistner.vscode-fileutils
    ];
  };
}
