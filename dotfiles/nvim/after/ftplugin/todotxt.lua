local map = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

map("n", "<leader>ts", "", { buffer = bufnr, desc = "+sort" })
map("n", "<leader>tss", function() require("todotxt").sort_tasks() end, { buffer = bufnr, desc = "Default" })

map("n", "<c-c>n", function() require("todotxt").cycle_priority() end, {
	buffer = bufnr,
	desc = "todo.txt: cycle priority",
})

map("n", "<cr>", function() require("todotxt").toggle_todo_state() end, {
	buffer = bufnr,
	desc = "todo.txt: toggle task state",
})

map("n", "<leader>td", function() require("todotxt").move_done_tasks() end, {
	buffer = bufnr,
	desc = "Move to done.txt",
})

map("n", "<leader>tsd", function() require("todotxt").sort_tasks_by_due_date() end, {
	buffer = bufnr,
	desc = "By due:date",
})

map("n", "<leader>tsP", function() require("todotxt").sort_tasks_by_priority() end, {
	buffer = bufnr,
	desc = "By (priority)",
})

map("n", "<leader>tsc", function() require("todotxt").sort_tasks_by_context() end, {
	buffer = bufnr,
	desc = "By @context",
})

map("n", "<leader>tsp", function() require("todotxt").sort_tasks_by_project() end, {
	buffer = bufnr,
	desc = "By +project",
})
