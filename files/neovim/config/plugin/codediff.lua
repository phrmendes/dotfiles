safely("later", function()
  require("codediff").setup()

  vim.keymap.set("n", "<leader>gD", "<cmd>CodeDiff<cr>", { desc = "Diff (repo)" })
  vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff file<cr>", { desc = "Diff (file)" })
end)
