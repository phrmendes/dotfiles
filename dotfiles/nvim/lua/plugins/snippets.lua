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

require("luasnip-latex-snippets").setup({
	use_treesitter = true,
	allow_on_markdown = true,
})

local snippets = {
	snippet({ trig = "im", name = "inline math" }, "$${1:${TM_SELECTED_TEXT}}$"),
	snippet({ trig = "bm", name = "block math" }, "$$\n${1:${TM_SELECTED_TEXT}}\n$$"),
	snippet({ trig = "done", name = "done" }, " ✅ " .. os.date("%Y-%m-%d") .. " $0"),
	snippet({ trig = "todo", name = "todo" }, "- [ ] #todo ${1:desc} ${2|🛫,⌛, |} ${3|📆, |} ${4|🔼,⏫, |}"),
	snippet({ trig = "ltex", name = "enable ltex" }, "<!-- LTeX: SETTINGS language=${1:pt-BR}-->$0"),
}

luasnip.add_snippets("markdown", snippets, { type = "autosnippets" })
luasnip.filetype_extend("markdown", { "quarto" })
