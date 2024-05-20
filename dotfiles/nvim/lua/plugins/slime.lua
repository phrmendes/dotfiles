vim.g.slime_cell_delimiter = "```"
vim.g.slime_bracketed_paste = 1

if vim.env.ZELLIJ then
	vim.g.slime_target = "zellij"
	vim.g.slime_default_config = { session_id = "current", relative_pane = "right" }
else
	vim.g.slime_target = "kitty"
	vim.g.slime_default_config = { window_id = 2, listen_on = vim.env.KITTY_LISTEN_ON }
end
