return {
	"ThePrimeagen/refactoring.nvim",
	ft = { "lua", "python" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	keys = {
		{ mode = { "n", "x" }, "<leader>r", function() require("refactoring").select_refactor() end, desc = "Refactoring" },
	},
}
