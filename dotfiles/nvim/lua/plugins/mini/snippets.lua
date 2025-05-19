local snippets = require("mini.snippets")

snippets.setup({
	snippets = {
		snippets.gen_loader.from_lang(),
	},
})

snippets.start_lsp_server()
