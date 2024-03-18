require("catppuccin").setup({
	flavour = "mocha",
	background = { dark = "mocha" },
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
	integrations = {
		treesitter_context = true,
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
	},
})

vim.cmd.colorscheme("catppuccin")
