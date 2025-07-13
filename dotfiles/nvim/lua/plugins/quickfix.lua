MiniDeps.later(function()
	MiniDeps.add({ source = "kevinhwang91/nvim-bqf", depends = { "nvim-treesitter/nvim-treesitter" } })

	require("bqf").setup({
		func_map = {
			drop = "o",
			open = "<cr>",
			openc = "<c-cr>",
			split = "<c-->",
			vsplit = "<c-\\>",
			tabc = "",
			tabdrop = "<c-t>",
		},
	})
end)
