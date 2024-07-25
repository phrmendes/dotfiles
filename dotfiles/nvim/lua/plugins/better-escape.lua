require("better_escape").setup({
	default_mappings = false,
	mappings = {
		i = {
			j = {
				k = "<Esc>",
			},
		},
		c = {
			j = {
				k = "<Esc>",
			},
		},
		t = {
			["<c-c>"] = {
				["<c-c>"] = "<Esc>",
			},
		},
		v = {
			j = {
				k = "<Esc>",
			},
		},
		s = {
			j = {
				k = "<Esc>",
			},
		},
	},
})
