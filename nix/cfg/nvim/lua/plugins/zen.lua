local zen = require("zen-mode")

zen.setup({
	plugins = {
		twilight = { enabled = true }, -- enable code block focus
		gitsigns = { enabled = false }, -- disables git signs
		tmux = { enabled = true }, -- disables the tmux statusline
		wezterm = {
			enabled = false,
			font = "+5",
		},
	},
})
