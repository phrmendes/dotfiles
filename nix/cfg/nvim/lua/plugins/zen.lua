local wk = require("which-key")
local zen = require("zen-mode")

zen.setup({
	plugins = {
		twilight = false,
		wezterm = {
			enabled = true,
			font = "+2",
		},
	},
})

wk.register({
	Z = { "<cmd>ZenMode<cr>", "Zen mode" },
}, { prefix = "<leader>", mode = "n" })
