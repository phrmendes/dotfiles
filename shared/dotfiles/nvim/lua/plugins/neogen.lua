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
	command = "<cmd>Neogen<cr>",
	desc = "Generate annotations",
})
