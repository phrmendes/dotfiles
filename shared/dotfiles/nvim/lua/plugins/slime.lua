local map = require("utils").map

vim.g.slime_cell_delimiter = "```"
vim.g.slime_bracketed_paste = 1
vim.g.slime_target = "kitty"

map({
	mode = { "n", "v" },
	key = "<C-c><C-c>",
	command = "<Plug>SlimeParagraphSend",
	desc = "Send to REPL",
})

map({
	mode = { "n", "v" },
	key = "<C-c><C-v>",
	command = "<Plug>SlimeConfig",
	desc = "Slime config",
})
