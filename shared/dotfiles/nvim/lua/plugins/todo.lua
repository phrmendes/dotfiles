local todo = require("todo-comments")

todo.setup()

vim.keymap.set("n", "<leader>tT", "<cmd>TodoQuickFix<cr>", { desc = "Document todos" })
vim.keymap.set("n", "<leader>tt", "<cmd>TodoLocList<cr>", { desc = "Workspace todos" })
vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next todo comment" })
