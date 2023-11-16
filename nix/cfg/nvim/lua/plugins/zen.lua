local zen = require("zen-mode")

local map = vim.keymap.set

zen.setup({
	plugins = {
		twilight = false,
		wezterm = {
			enabled = true,
			font = "+2",
		},
	},
})

map("n", "<Leader>Z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
