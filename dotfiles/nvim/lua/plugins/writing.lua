local later = require("mini.deps").later

later(function()
	vim.g.markdown_fenced_languages = { "python", "sh" }
	vim.g.mkdp_filetypes = { "markdown", "quarto" }

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})

	require("otter").setup({
		handle_leading_whitespace = true,
		buffers = {
			set_filetype = true,
		},
	})

	require("jupytext").setup({
		style = "markdown",
		output_extension = "md",
		force_ft = "markdown",
	})
end)
