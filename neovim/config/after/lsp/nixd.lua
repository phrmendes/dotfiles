return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.desktop.options',
        },
      },
    },
  },
}
