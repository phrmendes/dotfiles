local luasnip = require("luasnip")

luasnip.config.setup({
	enable_autosnippets = true,
	history = true,
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip-latex-snippets").setup({
	use_treesitter = true,
	allow_on_markdown = true,
})

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.filetype_extend("html", { "jinja", "template" })
luasnip.filetype_extend("latex", { "markdown", "quarto" })
