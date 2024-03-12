local later = require("mini.deps").later

later(function()
	local todo = require("todo-comments")

	todo.setup()
end)
