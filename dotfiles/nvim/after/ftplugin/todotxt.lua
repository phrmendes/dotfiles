local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ts", "", { buffer = bufnr, desc = "+sort" })
vim.keymap.set("n", "<leader>tss", function() require("todotxt").sort_tasks() end, { buffer = bufnr, desc = "Default" })

vim.keymap.set("n", "<c-c>n", function() require("todotxt").cycle_priority() end, {
	buffer = bufnr,
	desc = "todo.txt: cycle priority",
})

vim.keymap.set("n", "<cr>", function() require("todotxt").toggle_todo_state() end, {
	buffer = bufnr,
	desc = "todo.txt: toggle task state",
})

vim.keymap.set("n", "<leader>td", function() require("todotxt").move_done_tasks() end, {
	buffer = bufnr,
	desc = "Move to done.txt",
})

vim.keymap.set("n", "<leader>tsd", function() require("todotxt").sort_tasks_by_due_date() end, {
	buffer = bufnr,
	desc = "By due:date",
})

vim.keymap.set("n", "<leader>tsP", function() require("todotxt").sort_tasks_by_priority() end, {
	buffer = bufnr,
	desc = "By (priority)",
})

vim.keymap.set("n", "<leader>tsc", function() require("todotxt").sort_tasks_by_context() end, {
	buffer = bufnr,
	desc = "By @context",
})

vim.keymap.set("n", "<leader>tsp", function() require("todotxt").sort_tasks_by_project() end, {
	buffer = bufnr,
	desc = "By +project",
})
