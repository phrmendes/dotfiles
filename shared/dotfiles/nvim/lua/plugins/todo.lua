local todo = require("todo-comments")

local map = vim.keymap.set

todo.setup()

map("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
map("n", "]t", todo.jump_next, { desc = "Next todo comment" })

map("n", "<leader>T", "<cmd>TodoQuickFix<cr>", { desc = "Document todos" })
map("n", "<leader>t", "<cmd>TodoLocList<cr>", { desc = "Workspace todos" })
