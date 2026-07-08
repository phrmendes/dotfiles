safely(
  "later",
  function()
    require("conform").setup({
      notify_on_error = false,
      formatters_by_ft = {
        astro = { "oxfmt" },
        bash = { "shellharden", "shfmt" },
        css = { "oxfmt" },
        html = { "oxfmt" },
        htmldjango = { "djlint" },
        hurl = { "hurlfmt" },
        jinja2 = { "djlint" },
        json = { "jq" },
        just = { "just" },
        lua = { "stylua" },
        markdown = { "oxfmt", "panache" },
        nix = { "nixfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shellharden", "shfmt" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        yaml = { "yq" },
        ["yaml.ansible"] = { "yq" },
        zsh = { "shellharden", "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
)
