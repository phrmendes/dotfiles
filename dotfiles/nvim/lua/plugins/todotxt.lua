return {
	"phrmendes/todotxt.nvim",
	ft = "todotxt",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		todotxt = vim.env.HOME .. "/Documents/notes/todo.txt",
		donetxt = vim.env.HOME .. "/Documents/notes/done.txt",
	},
	keys = {
		{ "<leader>tn", function() require("todotxt").capture_todo() end, desc = "New entry" },
		{ "<leader>tt", function() require("todotxt").open_todo_file() end, desc = "Open" },
	},
}
