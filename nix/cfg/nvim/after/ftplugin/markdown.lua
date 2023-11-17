local utils = require("core.utils")

local map = vim.keymap.set

map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert bibtex reference" })
map("n", "<C-CR>", utils.md_toggle, { desc = "Toggle checkbox" })
map("n", "<Leader>p", "<cmd>PasteImg<cr>", { desc = "Paste image" })

map("n", "<Leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)" })
map("n", "<Leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info" })
map("n", "<Leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment" })
map("n", "<Leader>zv", "<Plug>ZViewDocument", { desc = "View exported document" })
map("n", "<Leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)" })
