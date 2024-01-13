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
	cmd = "<cmd>Neogen<cr>",
	desc = "Generate annotations",
})
