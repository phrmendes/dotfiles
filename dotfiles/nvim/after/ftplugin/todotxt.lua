local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<c-c>n", function() require("todotxt").cycle_priority() end, {
	desc = "Cycle priority",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>ts", function() require("todotxt").sort_tasks() end, {
	desc = "Sort",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>td", function() require("todotxt").move_done_tasks() end, {
	desc = "Move to done.txt",
	buffer = bufnr,
})

vim.keymap.set("n", "<c-c><c-x>", function() require("todotxt").toggle_todo_state() end, {
	desc = "todo.txt: toggle task state",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>tD", function() require("todotxt").sort_tasks_by_due_date() end, {
	desc = "Sort by due:date",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>tP", function() require("todotxt").sort_tasks_by_priority() end, {
	desc = "Sort by (priority)",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>tc", function() require("todotxt").sort_tasks_by_context() end, {
	desc = "Sort by @context",
	buffer = bufnr,
})

vim.keymap.set("n", "<leader>tp", function() require("todotxt").sort_tasks_by_project() end, {
	desc = "Sort by +project",
	buffer = bufnr,
})
