local todo = require("todo-comments")
local map = require("utils").map
local section = require("utils").section

todo.setup()

section({
	key = "<leader>t",
	name = "todo",
})

map({
	key = "[t",
	command = todo.jump_prev,
	desc = "Previous todo comment",
})

map({
	key = "]t",
	command = todo.jump_next,
	desc = "Next todo comment",
})

map({
	key = "<localleader>t",
	command = "<cmd>TodoTelescope<cr>",
	desc = "Todos",
})
