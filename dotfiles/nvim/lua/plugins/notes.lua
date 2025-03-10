return {
	"phrmendes/notes.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		path = vim.env.HOME .. "/Documents/notes",
	},
	keys = {
		{ "<leader>ns", function() require("notes").search() end, desc = "Search" },
		{ "<leader>n/", function() require("notes").grep_live() end, desc = "Live grep" },
		{ "<leader>nn", function() require("notes").new() end, desc = "New" },
	},
}
