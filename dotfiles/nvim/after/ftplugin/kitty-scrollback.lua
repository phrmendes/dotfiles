local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("x", "y", "<Plug>(KsbVisualYank)", { buffer = bufnr, desc = "Yank" })
vim.keymap.set("n", "y", "<Plug>(KsbNormalYank)", { buffer = bufnr, desc = "Yank" })
vim.keymap.set("n", "q", "<Plug>(KsbCloseOrQuitAll)", { buffer = bufnr, desc = "Quit" })
