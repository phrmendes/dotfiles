safely("now", function() require("mini.sessions").setup() end)

safely("later", function()
  vim.keymap.set("n", "<leader>R", MiniSessions.restart, { desc = "Restart (keep session)" })
end)
