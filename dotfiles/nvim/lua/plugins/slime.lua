local target, config

if vim.env.TMUX then
	target = "tmux"
	config = { socket_name = "default", target_pane = "{last}" }
else
	target = "kitty"
	config = { listen_on = os.getenv("KITTY_LISTEN_ON"), window_id = 2 }
end

vim.g.slime_bracketed_paste = 1
vim.g.slime_default_config = config
vim.g.slime_no_mappings = 1
vim.g.slime_target = target
