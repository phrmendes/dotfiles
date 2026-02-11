later(function()
  vim.pack.add({
    "https://github.com/tadmccorkle/markdown.nvim",
    "https://github.com/brianhuster/live-preview.nvim",
  })

  require("markdown").setup({
    on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
  })
end)
