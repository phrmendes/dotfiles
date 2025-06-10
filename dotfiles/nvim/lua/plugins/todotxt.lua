local map = vim.keymap.set

require("todotxt").setup({
	todotxt = vim.env.HOME .. "/Documents/notes/todo.txt",
	donetxt = vim.env.HOME .. "/Documents/notes/done.txt",
	create_commands = true,
})

map("n", "<leader>tn", function() require("todotxt").capture_todo() end, { desc = "New entry" })
map("n", "<leader>tt", function() require("todotxt").toggle_todotxt() end, { desc = "Open" })
