local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<localleader>%", "<cmd>source %<cr>", {
	desc = "Lua: source file",
	buffer = bufnr,
})

vim.keymap.set("n", "<localleader>.", ":.lua<cr>", {
	desc = "Lua: run line",
	buffer = bufnr,
})

vim.keymap.set("v", "<localleader>.", ":lua<cr>", {
	desc = "Lua: run",
	buffer = bufnr,
})
