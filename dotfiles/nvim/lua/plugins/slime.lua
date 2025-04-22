return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
		vim.g.slime_no_mappings = true
		vim.g.slime_target = "tmux"
	end,
	keys = {
		{ "<c-c><c-c>", "<Plug>SlimeParagraphSend", desc = "Slime: send to terminal", ft = "python" },
		{ "<c-c><c-s>", "<Plug>SlimeConfig", desc = "Slime: settings", ft = "python" },
		{ "<c-c><c-c>", "<Plug>SlimeRegionSend", desc = "Slime: send to terminal", ft = "python", mode = "x" },
	},
}
