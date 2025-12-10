MiniDeps.later(function()
	MiniDeps.add({ source = "jpalardy/vim-slime" })

	vim.g.slime_target = "neovim"
	vim.g.slime_bracketed_paste = 1
	vim.g.slime_no_mappings = true
	vim.g.slime_menu_config = 1
	vim.g.slime_neovim_ignore_unlisted = 1
	vim.g.slime_neovim_menu_delimiter = " | "
	vim.g.slime_neovim_menu_order = {
		{ name = "buffer=" },
		{ pid = "pid=" },
		{ jobid = "job id=" },
		{ term_title = "process=" },
	}
end)
