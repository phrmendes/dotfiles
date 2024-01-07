require("mini.bracketed").setup({
	diagnostic = { options = { float = false } },
	buffer = { suffix = "" },
	file = { suffix = "" },
	comment = { suffix = "" },
})

vim.keymap.set("n", "[{", "<Cmd>lua MiniBracketed.buffer('first')<CR>")
vim.keymap.set("n", "[[", "<Cmd>lua MiniBracketed.buffer('backward')<CR>")
vim.keymap.set("n", "]]", "<Cmd>lua MiniBracketed.buffer('forward')<CR>")
vim.keymap.set("n", "]}", "<Cmd>lua MiniBracketed.buffer('last')<CR>")
