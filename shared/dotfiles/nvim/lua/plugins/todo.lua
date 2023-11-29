local todo = require("todo-comments")
local wk = require("which-key")

local map = vim.keymap.set

map("n", "]t", function()
	todo.jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
	todo.jump_prev()
end, { desc = "Previous todo comment" })

wk.register({
	T = { "<cmd>TodoQuickFix<cr>", "Workspace todos" },
	t = { "<cmd>TodoLocList<cr>", "Document todos" },
}, { prefix = "<leader>t", mode = "n" })
