local utils = require("core.utils")

local map = vim.keymap.set

map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert bibtex reference" })
map("n", "<C-CR>", utils.md_toggle, { desc = "Toggle checkbox" })
map("n", "<Leader>p", "<cmd>PasteImg<cr>", { desc = "Paste image" })
