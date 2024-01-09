local map = require("utils").map

require("mini.bracketed").setup({
	diagnostic = { options = { float = false } },
	buffer = { suffix = "" },
	file = { suffix = "" },
	comment = { suffix = "" },
})

map({
	key = "[{",
	cmd = "<Cmd>lua MiniBracketed.buffer('first')<CR>",
	desc = "First buffer",
})

map({
	key = "[[",
	cmd = "<Cmd>lua MiniBracketed.buffer('backward')<CR>",
	desc = "Previous buffer",
})

map({
	key = "]]",
	cmd = "<Cmd>lua MiniBracketed.buffer('forward')<CR>",
	desc = "Next buffer",
})

map({
	key = "]}",
	cmd = "<Cmd>lua MiniBracketed.buffer('last')<CR>",
	desc = "Last buffer",
})
