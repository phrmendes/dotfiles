require("zen-mode").setup({
	plugins = {
		tmux = { enabled = false },
		twilight = { enabled = false },
		kitty = {
			enabled = true,
			font = "+4",
		},
	},
})

require("utils").map({
	key = "<leader>Z",
	command = "<cmd>ZenMode<cr>",
	desc = "Zen mode",
})
