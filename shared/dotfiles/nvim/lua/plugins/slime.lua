local map = require("utils").map

vim.g.slime_cell_delimiter = "```"
vim.g.slime_bracketed_paste = 1
vim.g.slime_target = "kitty"
vim.g.slime_python_ipython = 1
vim.g.slime_default_config = { window_id = 2, listen_on = vim.env.KITTY_LISTEN_ON }

map({
	mode = { "n", "v" },
	key = "<C-c><C-c>",
	cmd = "<Plug>SlimeParagraphSend",
	desc = "Send to REPL",
})

map({
	mode = { "n", "v" },
	key = "<C-c><C-v>",
	cmd = "<Plug>SlimeConfig",
	desc = "Slime config",
})
