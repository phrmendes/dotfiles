MiniDeps.now(function()
	require("todotxt").setup({
		todotxt = vim.env.HOME .. "/Documents/notes/todo.txt",
		donetxt = vim.env.HOME .. "/Documents/notes/done.txt",
		create_commands = true,
	})

	vim.keymap.set("n", "<leader>tn", function() require("todotxt").capture_todo() end, { desc = "New entry" })
	vim.keymap.set("n", "<leader>tt", function() require("todotxt").toggle_todotxt() end, { desc = "Open" })
end)
