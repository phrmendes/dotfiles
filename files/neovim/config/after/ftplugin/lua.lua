vim.keymap.set("n", "<localleader>%", "<cmd>source %<cr>", { buffer = 0, desc = "lua: source file" })
vim.keymap.set("n", "<localleader>.", ":.lua<cr>", { buffer = 0, desc = "lua: run line" })
vim.keymap.set("x", "<localleader>.", ":lua<cr>", { buffer = 0, desc = "lua: run selection" })
