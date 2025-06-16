local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({ source = "jpalardy/vim-slime" })

	local target, config

	if vim.env.TMUX then
		target = "tmux"
		config = { socket_name = "default", target_pane = "{last}" }
	else
		target = "wezterm"
		config = { pane_direction = "right" }
	end

	vim.g.slime_target = target
	vim.g.slime_default_config = config
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
end)
