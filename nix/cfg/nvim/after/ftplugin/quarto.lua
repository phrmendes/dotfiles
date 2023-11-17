local quarto = require("quarto")

local map = vim.keymap.set

quarto.setup()

map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert bibtex reference" })
