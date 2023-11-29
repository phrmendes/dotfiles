local wk = require("which-key")

require("zen-mode").setup({
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
