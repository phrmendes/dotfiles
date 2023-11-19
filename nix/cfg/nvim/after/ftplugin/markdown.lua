local utils = require("core.utils")
local wk = require("which-key")

local map = vim.keymap.set

map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert bibtex reference" })
map("n", "<C-CR>", utils.md_toggle, { desc = "Toggle checkbox" })

wk.register({
	p = { "<cmd>PasteImage<cr>", "Paste image" },
}, { prefix = "<leader>", mode = "n" })

wk.register({
	name = "zotero",
	c = { "<Plug>ZCitationCompleteInfo", "Citation info (complete)" },
	i = { "<Plug>ZCitationInfo", "Citation info" },
	o = { "<Plug>ZOpenAttachment", "Open attachment" },
	v = { "<Plug>ZViewDocument", "View exported document" },
	y = { "<Plug>ZCitationYamlRef", "Citation info (yaml)" },
}, { prefix = "<leader>z", mode = "n" })
