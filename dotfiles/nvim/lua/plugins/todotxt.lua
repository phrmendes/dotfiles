return {
	"phrmendes/todotxt.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		todotxt = vim.env.HOME .. "/Documents/notes/todo.txt",
		donetxt = vim.env.HOME .. "/Documents/notes/done.txt",
	},
	keys = {
		{ "<leader>t", "", desc = "+todo.txt" },
		{
			"<c-c>n",
			function() require("todotxt").cycle_priority() end,
			desc = "todo.txt: cycle priority",
			ft = "todotxt",
		},
		{
			"<c-c>x",
			function() require("todotxt").toggle_todo_state() end,
			desc = "todo.txt: toggle task state",
			ft = "todotxt",
		},
		{
			"<leader>ts",
			function() require("todotxt").sort_tasks() end,
			desc = "Sort",
			ft = "todotxt",
		},
		{
			"<leader>td",
			function() require("todotxt").move_done_tasks() end,
			desc = "Move to done.txt",
			ft = "todotxt",
		},
		{
			"<leader>tD",
			function() require("todotxt").sort_tasks_by_due_date() end,
			desc = "Sort by due:date",
			ft = "todotxt",
		},
		{
			"<leader>tP",
			function() require("todotxt").sort_tasks_by_priority() end,
			desc = "Sort by (priority)",
			ft = "todotxt",
		},
		{
			"<leader>tc",
			function() require("todotxt").sort_tasks_by_context() end,
			desc = "Sort by @context",
			ft = "todotxt",
		},
		{
			"<leader>tp",
			function() require("todotxt").sort_tasks_by_project() end,
			desc = "Sort by +project",
			ft = "todotxt",
		},
		{
			"<leader>tn",
			function() require("todotxt").capture_todo() end,
			desc = "New entry",
			ft = "todotxt",
		},
		{
			"<leader>tt",
			function() require("todotxt").open_todo_file() end,
			desc = "Open",
		},
	},
}
