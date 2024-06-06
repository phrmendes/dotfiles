vim.g.slime_bracketed_paste = 1

if vim.env.TMUX then
	vim.g.slime_target = "tmux"
	vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
else
	vim.g.slime_target = "kitty"
end
