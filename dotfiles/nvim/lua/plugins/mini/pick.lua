MiniDeps.now(function()
	require("mini.pick").setup({
		mappings = {
			refine = "<c-r>",
			refine_marked = "<a-r>",
			paste = "<c-y>",
			choose_marked = "<c-q>",
		},
		window = {
			config = {
				border = vim.g.border,
			},
		},
	})

	vim.ui.select = MiniPick.ui_select
end)
