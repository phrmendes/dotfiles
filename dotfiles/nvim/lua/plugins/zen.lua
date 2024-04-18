local later = require("mini.deps").later

later(function()
	require("zen-mode").setup({
		plugins = {
			twilight = {
				enabled = false,
			},
			kitty = {
				enabled = true,
				font = "+2",
			},
		},
	})
end)
