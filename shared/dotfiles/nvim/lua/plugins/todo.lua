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
	key = "<leader>T",
	command = "<cmd>TodoQuickFix<cr>",
	desc = "Document todos",
})

map({
	key = "<leader>t",
	command = "<cmd>TodoLocList<cr>",
	desc = "Workspace todos",
})
