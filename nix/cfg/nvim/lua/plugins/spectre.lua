local spectre = require("spectre")

local map = vim.keymap.set

spectre.setup({
	open_cmd = "noswapfile vnew",
})

map("n", "<Leader>fs", spectre.toggle, { desc = "Search and replace" })
