return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_default_config = { listen_on = vim.env.KITTY_LISTEN_ON, window_id = 2 }
		vim.g.slime_no_mappings = true
		vim.g.slime_target = "kitty"
	end,
	keys = {
		{ "<c-c><c-c>", "<Plug>SlimeParagraphSend", desc = "Slime: send to terminal" },
		{ "<c-c><c-s>", "<Plug>SlimeConfig", desc = "Slime: settings" },
		{ mode = "v", "<c-c><c-c>", "<Plug>SlimeRegionSend", desc = "Slime: send to terminal" },
	},
}
