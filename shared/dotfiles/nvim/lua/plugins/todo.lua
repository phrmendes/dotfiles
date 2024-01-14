local todo = require("todo-comments")
local map = require("utils").map

todo.setup()

map({
	key = "[t",
	cmd = todo.jump_prev,
	desc = "Previous todo comment",
})

map({
	key = "]t",
	cmd = todo.jump_next,
	desc = "Next todo comment",
})

map({
	key = "<leader>t",
	cmd = "<CMD>TodoTelescope<CR>",
	desc = "Todos",
})
