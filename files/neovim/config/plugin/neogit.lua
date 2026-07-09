safely("later", function()
  require("neogit").setup({})

  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=auto<cr>", { desc = "Neogit" })
  vim.keymap.set("n", "<leader>gD", "<cmd>Diff<cr>", { desc = "Diff (repo)" })
end)
