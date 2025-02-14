return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"j-hui/fidget.nvim",
	},
	ft = "http",
	build = false,
	cmd = { "Rest" },
	keys = {
		{ "<c-c>r", "<cmd>Rest run<cr>", ft = "http", desc = "Rest: run" },
	},
}
