local illuminate = require("illuminate")

illuminate.configure({
	delay = 200,
	large_file_cutoff = 2000,
	large_file_overrides = {
		providers = { "lsp" },
	},
	filetypes_denylist = {
		"NvimTree",
		"TelescopePrompt",
		"fugitive",
		"lazygit",
	},
})
