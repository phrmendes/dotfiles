safely("later", function()
  local lint = require("lint")

  lint.linters.nu_lint = function()
    local args = { "--format", "compact" }
    local root = vim.fs.root(0, "nu-lint.toml")
    if root then vim.list_extend(args, { "--config", vim.fs.joinpath(root, "nu-lint.toml") }) end

    return {
      cmd = "nu-lint",
      args = args,
      ignore_exitcode = true,
      parser = require("lint.parser").from_pattern(
        "^(.-):(%d+):(%d+): (%a+)%(([^)]+)%): (.+)$",
        { "file", "lnum", "col", "severity", "code", "message" },
        { error = vim.diagnostic.severity.ERROR, warning = vim.diagnostic.severity.WARN, hint = vim.diagnostic.severity.HINT },
        { source = "nu-lint" }
      ),
    }
  end

  lint.linters_by_ft = {
    astro = { "eslint" },
    bash = { "shellcheck" },
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

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    desc = "Run linters",
    group = vim.api.nvim_create_augroup("UserLint", {}),
    callback = function() lint.try_lint(nil, { ignore_errors = true }) end,
  })
end)
