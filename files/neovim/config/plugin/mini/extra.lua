safely("later", function()
  require("mini.extra").setup()

  vim.keymap.set("n", "<c-s-p>", MiniExtra.pickers.commands, { desc = "Commands" })
  vim.keymap.set("n", "<leader>:", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "`:` history" })
  vim.keymap.set("n", "<leader>K", MiniExtra.pickers.keymaps, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>gm", function() MiniExtra.pickers.git_files({ scope = "modified" }) end, { desc = "Modified files" })
  vim.keymap.set("n", "<leader>m", MiniExtra.pickers.marks, { desc = "Marks" })
end)
