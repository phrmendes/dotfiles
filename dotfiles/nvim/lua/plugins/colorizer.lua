local later = require("mini.deps").later

later(function()
	require("colorizer").setup({
		filetypes = {
			"css",
			"html",
			"json",
		},
		user_default_options = {
			tailwind = true,
			css = true,
			css_fn = true,
			mode = "background",
		},
	})
end)
