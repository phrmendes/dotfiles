MiniDeps.later(function()
	local snippets = require("mini.snippets")

	snippets.setup({
		snippets = {
			snippets.gen_loader.from_lang(),
		},
		mappings = {
			expand = "<c-j>",
			stop = "<c-c>",
			jump_next = "",
			jump_prev = "",
		},
	})
end)
