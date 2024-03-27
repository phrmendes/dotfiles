vim.g.slime_cell_delimiter = "```"
vim.g.slime_bracketed_paste = 1

if vim.env.TMUX then
	vim.g.slime_target = "tmux"
	vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
else
	vim.g.slime_target = "kitty"
	vim.g.slime_default_config = { window_id = 2, listen_on = vim.env.KITTY_LISTEN_ON }
end
