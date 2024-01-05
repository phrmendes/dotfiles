local map = require("utils").map

vim.g.slime_cell_delimiter = "```"
vim.g.slime_bracketed_paste = 1
vim.g.slime_target = "kitty"
vim.g.slime_scala_ammonite = 1
vim.g.slime_python_ipython = 1
vim.g.slime_default_config = { window_id = 2, listen_on = vim.env.KITTY_LISTEN_ON }

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
