local todo = require("todo-comments")
local wk = require("which-key")

local map = vim.api.nvim_set_keymap

map("n", "]t", function()
	todo.jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
	todo.jump_prev()
end, { desc = "Previous todo comment" })

wk.register({
	name = "todo",
	p = { "<cmd>TodoQuickfix<cr>", "Todos (project)" },
	d = { "<cmd>TodoQuickfix<cr>", "Todos (document)" },
	s = { "<cmd>TodoTelescope<cr>", "Search todos" },
}, { prefix = "<leader>", mode = "n" })
