local luasnip = require("luasnip")

local snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, {
	priority = 100,
})

luasnip.config.setup({
	enable_autosnippets = true,
	history = true,
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip.loaders.from_vscode").lazy_load()

if vim.fn.has("mac") == 0 then
	require("luasnip-latex-snippets").setup({
		use_treesitter = true,
		allow_on_markdown = true,
	})
end

local snippets = {
	snippet({ trig = "im", name = "inline math" }, "$${1:${TM_SELECTED_TEXT}}$"),
	snippet({ trig = "bm", name = "block math" }, "$$\n${1:${TM_SELECTED_TEXT}}\n$$"),
	snippet({ trig = "ltex", name = "enable ltex" }, "<!-- LTeX: SETTINGS language=${1:pt-BR}-->$0"),
}

luasnip.add_snippets("markdown", snippets)
luasnip.filetype_extend("markdown", { "quarto" })
