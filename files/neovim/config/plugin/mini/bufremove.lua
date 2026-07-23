safely("later", function()
  require("mini.bufremove").setup()

  vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout" })
end)
