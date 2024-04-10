local later = require("mini.deps").later

later(function()
	require("jupytext").setup({
		custom_language_formatting = {
			python = {
				extension = "qmd",
				style = "quarto",
				force_ft = "quarto",
			},
		},
	})
end)
