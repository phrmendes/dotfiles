local later = require("mini.deps").later

later(function()
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
end)
