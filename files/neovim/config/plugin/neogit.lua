safely("later", function()
  require("neogit").setup({})
  require("codediff").setup()

  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=auto<cr>", { desc = "Neogit" })
  vim.keymap.set("n", "<leader>gD", "<cmd>CodeDiff<cr>", { desc = "Diff (repo)" })
end)
