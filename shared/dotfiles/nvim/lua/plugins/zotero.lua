local map = require("utils").map
local section = require("utils").section

section({
	key = "<leader>z",
	name = "zotero",
	buffer = 0,
})

map({
	key = "<leader>zc",
	cmd = "<Plug>ZCitationCompleteInfo",
	buffer = 0,
	desc = "Citation info (complete)",
})

map({
	key = "<leader>zi",
	cmd = "<Plug>ZCitationInfo",
	desc = "Citation info",
	buffer = 0,
})

map({
	key = "<leader>zo",
	cmd = "<Plug>ZOpenAttachment",
	desc = "Open attachment",
	buffer = 0,
})

map({
	key = "<leader>zv",
	cmd = "<Plug>ZViewDocument",
	desc = "View exported document",
	buffer = 0,
})

map({
	key = "<leader>zy",
	cmd = "<Plug>ZCitationYamlRef",
	desc = "Citation info (yaml)",
	buffer = 0,
})
