require("zen-mode").setup({
	plugins = {
		twilight = false,
		wezterm = {
			enabled = true,
			font = "+2",
		},
	},
})

require("utils").map({
	key = "<leader>Z",
	command = "<cmd>ZenMode<cr>",
	desc = "Zen mode",
})
