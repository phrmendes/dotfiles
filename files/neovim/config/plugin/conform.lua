safely(
  "later",
  function()
    require("conform").setup({
      notify_on_error = false,
      formatters = {
        kdlfmt = { append_args = { "--kdl-version", "v1" } },
        tofu_fmt = {
          command = "tofu",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
      formatters_by_ft = {
        astro = { "prettier" },
        bash = { "shellharden", "shfmt" },
        css = { "prettier" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        jinja2 = { "djlint" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shellharden", "shfmt" },
        terraform = { "tofu_fmt" },
        tex = { "tex-fmt" },
        toml = { "taplo" },
        yaml = { "prettier" },
        kdl = { "kdlfmt" },
        nu = { "nufmt" },
        rust = { "rustfmt" },
        ["yaml.ansible"] = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
)
