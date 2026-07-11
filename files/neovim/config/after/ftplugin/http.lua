vim.keymap.set("n", "<leader>kk", require("kulala").run, { desc = "Send request" })
vim.keymap.set("n", "<leader>ka", require("kulala").run_all, { desc = "Send all requests" })
