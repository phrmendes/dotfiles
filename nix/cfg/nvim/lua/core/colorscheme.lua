local catppuccin = require("catppuccin")

catppuccin.setup({
	flavour = "mocha",
	background = { dark = "mocha" },
	integrations = {
		treesitter_context = true,
		which_key = true,
		fidget = true,
	},
})

vim.cmd.colorscheme("catppuccin")
