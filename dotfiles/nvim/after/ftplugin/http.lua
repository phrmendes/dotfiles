local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ka", function() require("kulala").run_all() end, { buffer = bufnr, desc = "Send all" })
vim.keymap.set("n", "<leader>ki", function() require("kulala").inspect() end, { buffer = bufnr, desc = "Inspect" })
vim.keymap.set("n", "<leader>kq", function() require("kulala").close() end, { buffer = bufnr, desc = "Close" })
vim.keymap.set("n", "<leader>kr", function() require("kulala").replay() end, { buffer = bufnr, desc = "Replay" })
vim.keymap.set({ "n", "x" }, "<leader>kk", function() require("kulala").run() end, { buffer = bufnr, desc = "Send" })

vim.keymap.set("n", "<leader>kc", function() require("kulala").copy() end, {
  buffer = bufnr,
  desc = "Copy as a curl command",
})

vim.keymap.set("n", "<leader>kf", function() require("kulala").from_curl() end, {
  buffer = bufnr,
  desc = "Paste curl from clipboard",
})

vim.keymap.set("n", "<leader>kS", function() require("kulala").show_stats() end, {
  buffer = bufnr,
  desc = "Statistics",
})
