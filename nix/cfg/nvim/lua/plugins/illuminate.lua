local illuminate = require("illuminate")

illuminate.configure({
	filetypes_denylist = {
		"NvimTree",
		"TelescopePrompt",
		"fugitive",
		"lazygit",
	},
})
