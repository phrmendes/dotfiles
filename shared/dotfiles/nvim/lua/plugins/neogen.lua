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

vim.keymap.set("n", "<leader>n", "<cmd>Neogen<cr>", { desc = "Generate annotations" })
