local config
local target

if vim.env.TMUX then
	target = "tmux"
	config = { socket_name = "default", target_pane = "{last}" }
else
	target = "kitty"
	config = { listen_on = vim.env.KITTY_LISTEN_ON, window_id = 2 }
end

vim.g.slime_no_mappings = true
vim.g.slime_target = target
vim.g.slime_default_config = config
