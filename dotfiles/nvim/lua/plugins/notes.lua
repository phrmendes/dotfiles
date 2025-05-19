return {
	"phrmendes/notes.nvim",
	dev = true,
	dependencies = { "echasnovski/mini.nvim" },
	opts = {
		path = vim.env.HOME .. "/Documents/notes",
		picker = "mini",
	},
	keys = {
		{ "<leader>n", "", desc = "+notes" },
		{ "<leader>ns", function() require("notes").search() end, desc = "Search" },
		{ "<leader>n/", function() require("notes").grep_live() end, desc = "Live grep" },
		{ "<leader>nn", function() require("notes").new() end, desc = "New" },
	},
}
