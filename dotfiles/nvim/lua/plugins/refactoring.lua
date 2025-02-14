return {
	"ThePrimeagen/refactoring.nvim",
	ft = { "lua", "python" },
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	keys = {
		{
			"<leader>r",
			function() require("refactoring").select_refactor() end,
			mode = { "n", "x" },
			desc = "Refactoring",
		},
	},
}
