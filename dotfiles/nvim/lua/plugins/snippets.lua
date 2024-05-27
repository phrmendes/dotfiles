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
	lua = {
		snippet(
			{ trig = "acmd", name = "autocmd" },
			[[
vim.api.nvim_create_autocmd(${1:event}, {
	group = require("utils").augroups.${2:group},
	pattern = ${3:pattern},
	callback = $0,
})
]]
		),
	},
	markdown = {
		snippet({ trig = "im", name = "inline math" }, "$${1:equation}$\n$0"),
		snippet({ trig = "bm", name = "block math" }, "$$\n${1:equation\n$$\n$0"),
		snippet({ trig = "ltex", name = "enable ltex" }, "<!-- LTeX: SETTINGS language=${1:pt-BR}-->$0"),
	},
}

for key, value in pairs(snippets) do
	luasnip.add_snippets(key, value)
end

luasnip.filetype_extend("markdown", { "quarto" })
