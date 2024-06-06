vim.g.slime_bracketed_paste = 1
vim.g.slime_no_mappings = 1

if vim.env.TMUX then
	vim.g.slime_target = "tmux"
	vim.slime_default_config = { socket_name = "default", target_pane = "{last}" }
	vim.g.slime_dont_ask_default = 1
else
	vim.g.slime_target = "kitty"
end
