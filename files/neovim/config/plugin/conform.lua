safely(
  "later",
  function()
    require("conform").setup({
      notify_on_error = false,
      formatters_by_ft = {
        astro = { "prettier" },
        bash = { "shellharden", "shfmt" },
        css = { "prettier" },
        elixir = { "mix" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        jinja2 = { "djlint" },
        json = { "jq" },
        just = { "just" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shellharden", "shfmt" },
        terraform = { "terraform_fmt" },
        tex = { "tex-fmt" },
        toml = { "taplo" },
        yaml = { "yq" },
        kdl = { "kdlfmt" },
        nu = { "nufmt" },
        rust = { "rustfmt" },
        ["yaml.ansible"] = { "yq" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
)
