local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({ source = "jpalardy/vim-slime" })

	vim.g.slime_target = "wezterm"
	vim.g.slime_default_config = { pane_direction = "right" }
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
end)
