later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

  require("lint").linters_by_ft = {
    htmldjango = { "djlint" },
    jinja2 = { "djlint" },
    terraform = { "tflint" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    desc = "Run linters on file save, read, or leave insert mode",
    group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
    callback = function() require("lint").try_lint() end,
  })
end)
