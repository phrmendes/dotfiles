local later = require("mini.deps").later

later(function()
	require("otter").setup({
		handle_leading_whitespace = true,
		buffers = {
			set_filetype = true,
		},
	})

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})
end)
