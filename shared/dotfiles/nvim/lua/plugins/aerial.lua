local map = require("utils").map

require("aerial").setup({
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
	end,
})

map({
	key = "<localleader>a",
	command = "<cmd>AerialToggle<cr>",
	desc = "Aerial",
})
