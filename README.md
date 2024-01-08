# Dotfiles

Dotfiles files for my personal computer.

Install Nix package manager:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

To install the python debugger:

```sh
mkdir ~/.virtualenvs
cd ~/.virtualenvs
python -m venv tools
debugpy/bin/python -m pip install debugpy
```
