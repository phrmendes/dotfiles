later(function()
  vim.pack.add({ "https://github.com/mbbill/undotree" })

  vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })
end)
