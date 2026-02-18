later(function()
  require("markdown").setup({
    on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
  })
end)
