safely(
  "later",
  function()
    require("conform").setup({
      notify_on_error = false,
      formatters_by_ft = {
        css = { "prettier" },
        astro = { "prettier" },
        htmldjango = { "djlint" },
        html = { "prettier" },
        http = { "kulala-fmt" },
        jinja2 = { "djlint" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shellharden" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        yaml = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
)
