local catppuccin = require("catppuccin")

catppuccin.setup({
	flavour = "mocha",
	background = { dark = "mocha" },
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
	integrations = {
		treesitter_context = true,
		which_key = true,
		fidget = true,
	},
})

vim.cmd.colorscheme("catppuccin")
