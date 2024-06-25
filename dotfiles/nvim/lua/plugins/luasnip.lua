local luasnip = require("luasnip")

local snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, {
	priority = 100,
})

require("luasnip-latex-snippets").setup({
	use_treesitter = true,
	allow_on_markdown = true,
})

luasnip.config.setup({
	enable_autosnippets = true,
	history = true,
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip.loaders.from_vscode").lazy_load()

local snippets = {
	markdown = {
		snippet({ trig = "ltex", name = "enable ltex" }, "<!-- LTeX: SETTINGS language=${1:pt-BR}-->$0"),
	},
}

for key, value in pairs(snippets) do
	luasnip.add_snippets(key, value)
end

luasnip.filetype_extend("quarto", { "markdown" })
luasnip.filetype_extend("jinja", { "html" })
luasnip.filetype_extend("template", { "html" })
