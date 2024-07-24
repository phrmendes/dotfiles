vim.g.slime_no_mappings = 1

if vim.env.TMUX then
	vim.g.slime_target = "tmux"
else
	vim.g.slime_target = "kitty"
	vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
end

if vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV then
	vim.g.slime_python_ipython = 1
else
	vim.g.slime_bracketed_paste = 1
end
