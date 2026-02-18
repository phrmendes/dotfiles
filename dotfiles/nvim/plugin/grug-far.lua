later(function()
  require("grug-far").setup({ transient = true })

  vim.keymap.set("n", "<leader>G", function() require("grug-far").open() end, { desc = "grug-far" })
  vim.keymap.set("v", "<leader>G", function() require("grug-far").with_visual_selection() end, { desc = "grug-far" })
end)
