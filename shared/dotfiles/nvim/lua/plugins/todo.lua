local todo = require("todo-comments")
local map = require("utils").map

todo.setup()

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
	key = "<leader>t",
	command = "<cmd>TodoTelescope<cr>",
	desc = "Todos",
})
