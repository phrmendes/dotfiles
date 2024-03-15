local later = require("mini.deps").later

later(function()
	vim.g.markdown_fenced_languages = { "python", "sh" }
	vim.g.mkdp_filetypes = { "markdown", "quarto" }
	vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_auto_open_output = false

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
end)
