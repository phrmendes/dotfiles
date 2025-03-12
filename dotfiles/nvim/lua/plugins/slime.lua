return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_default_config = { pane_direction = "right" }
		vim.g.slime_no_mappings = true
		vim.g.slime_target = "wezterm"
	end,
	keys = {
		{ "<c-c><c-c>", "<Plug>SlimeParagraphSend", desc = "Slime: send to terminal" },
		{ "<c-c><c-s>", "<Plug>SlimeConfig", desc = "Slime: settings" },
		{ mode = "v", "<c-c><c-c>", "<Plug>SlimeRegionSend", desc = "Slime: send to terminal" },
	},
}
