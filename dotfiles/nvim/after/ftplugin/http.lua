vim.keymap.set("n", "<c-c>r", "<cmd>Rest run<cr>", {
	desc = "Rest: run",
	buffer = vim.api.nvim_get_current_buf(),
})
