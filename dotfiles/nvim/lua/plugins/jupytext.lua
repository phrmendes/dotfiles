require("jupytext").setup({
	custom_language_formatting = {
		python = {
			extension = "qmd",
			style = "quarto",
			force_ft = "quarto",
		},
	},
})
