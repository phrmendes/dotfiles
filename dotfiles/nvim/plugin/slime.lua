MiniDeps.later(function()
	MiniDeps.add({ source = "jpalardy/vim-slime" })

	vim.g.slime_target = "neovim"
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
end)
