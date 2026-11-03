safely("later", function()
  local lint = require("lint")

  lint.linters.nu_lint = {
    cmd = "nu-lint",
    args = {
      "--format",
      "compact",
      "--config",
      function()
        local root = vim.fs.root(0, "nu-lint.toml")

        return root and vim.fs.joinpath(root, "nu-lint.toml") or ""
      end,
    },
    stream = "stderr",
    ignore_exitcode = true,
    name = "nu_lint",
    parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", { source = "nu-lint" }),
  }

  lint.linters_by_ft = {
    astro = { "eslint" },
    bash = { "shellcheck" },
    elixir = { "credo" },
    htmldjango = { "djlint" },
    javascript = { "eslint" },
    jinja2 = { "djlint" },
    jsx = { "eslint" },
    nu = { "nu_lint" },
    rust = { "clippy" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
    tsx = { "eslint" },
    typescript = { "eslint" },
    ["yaml.ansible"] = { "ansible_lint" },
  }

  safely("event:BufWritePost,BufReadPost,InsertLeave", function() lint.try_lint() end)
end)
