local hostname = vim.trim(vim.fn.system("hostname"))

return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.' .. hostname .. ".options",
        },
      },
    },
  },
}
