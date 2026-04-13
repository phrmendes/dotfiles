safely(
  "later",
  function()
    require("conform").setup({
      notify_on_error = false,
      formatters_by_ft = {
        astro = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        hurl = { "hurlfmt" },
        jinja2 = { "djlint" },
        json = { "prettier" },
        just = { "just" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shellharden", "shfmt" },
        bash = { "shellharden", "shfmt" },
        zsh = { "shellharden", "shfmt" },
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
