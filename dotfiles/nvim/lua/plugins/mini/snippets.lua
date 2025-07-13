MiniDeps.later(function()
	local snippets = require("mini.snippets")

	snippets.setup({
		snippets = {
			snippets.gen_loader.from_lang(),
		},
	})
end)
