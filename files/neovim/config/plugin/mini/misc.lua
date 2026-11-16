safely("later", function()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()

  vim.keymap.set("n", "<leader>=", MiniMisc.resize_window, { desc = "Resize to default size" })
  vim.keymap.set("n", "<leader>Z", require("helpers").zoom, { desc = "Zoom" })
end)
