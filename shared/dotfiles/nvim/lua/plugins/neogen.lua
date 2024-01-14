require("neogen").setup({
	snippet_engine = "luasnip",
	enabled = true,
	languages = {
		python = {
			template = {
				annotation_convention = "numpydoc",
			},
		},
	},
})

require("utils").map({
	key = "<leader>n",
	cmd = "<CMD>Neogen<CR>",
	desc = "Generate annotations",
})
