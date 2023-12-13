require("aerial").setup({
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
	end,
})
vim.keymap.set("n", "<localleader>a", "<cmd>AerialToggle!<cr>", { desc = "Aerial" })
