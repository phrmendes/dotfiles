MiniDeps.later(function()
	MiniDeps.add({ source = "jpalardy/vim-slime" })

	if vim.env.TMUX then
		vim.g.slime_target = "tmux"
		vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
	else
		vim.g.slime_target = "kitty"
		vim.g.slime_default_config = { listen_on = vim.env.KITTY_LISTEN_ON, window_id = 2 }
	end

	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
end)
