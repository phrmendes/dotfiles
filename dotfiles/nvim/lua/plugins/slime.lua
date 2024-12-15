local config, target

if vim.env.TMUX then
	config = { socket_name = "default", target_pane = "{last}" }
	target = "tmux"
else
	config = { pane_direction = "right" }
	target = "wezterm"
end

vim.g.slime_bracketed_paste = 1
vim.g.slime_default_config = config
vim.g.slime_no_mappings = true
vim.g.slime_target = target
