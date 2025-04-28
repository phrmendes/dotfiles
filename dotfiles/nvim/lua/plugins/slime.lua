return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_target = "wezterm"
		vim.g.slime_default_config = { pane_direction = "right" }
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_no_mappings = true
	end,
	keys = {
		{ "<c-c><c-c>", "<Plug>SlimeParagraphSend", desc = "Slime: send to terminal", ft = "python" },
		{ "<c-c><c-s>", "<Plug>SlimeConfig", desc = "Slime: settings", ft = "python" },
		{ "<c-c><c-c>", "<Plug>SlimeRegionSend", desc = "Slime: send to terminal", ft = "python", mode = "x" },
	},
}
