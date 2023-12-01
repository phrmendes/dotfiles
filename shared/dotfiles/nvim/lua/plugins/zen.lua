require("zen-mode").setup({
	plugins = {
		twilight = false,
		wezterm = {
			enabled = true,
			font = "+2",
		},
	},
})

vim.keymap.set("n", "<leader>Z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
