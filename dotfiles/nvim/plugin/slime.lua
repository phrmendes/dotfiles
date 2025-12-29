later(function()
	vim.pack.add({ "https://github.com/jpalardy/vim-slime" })

	vim.g.slime_target = "kitty"
	vim.g.slime_default_config = { listen_on = vim.env.KITTY_LISTEN_ON, window_id = 2 }
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
end)
