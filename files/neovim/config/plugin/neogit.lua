safely("later", function()
  require("neogit").setup({
    diff_viewer = "codediff",
    integrations = { codediff = true },
  })

  vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=auto<cr>", { desc = "Neogit" })
  vim.keymap.set("n", "<leader>gD", "<cmd>CodeDiff<cr>", { desc = "CodeDiff (repo)" })
end)
