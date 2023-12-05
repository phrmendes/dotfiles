require("quarto").setup()

vim.keymap.set("n", "<localleader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview", buffer = 0 })
vim.keymap.set("n", "<localleader>e", require("nabla").popup, { desc = "Markdown preview", buffer = 0 })
