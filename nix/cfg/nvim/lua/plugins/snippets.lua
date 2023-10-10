-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local parse_snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, {
	wordTrig = true,
})

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup({ enable_autosnippets = true })
vscode_loaders.lazy_load()

-- [[ snippets ]] --------------------------------------------------------
local markdown_snippets = {
	parse_snippet({ trig = "journal", name = "journal" }, "# " .. os.date("%a, %d %b %Y") .. "\n"),
	parse_snippet({ trig = "metadata", name = "metadata" }, "\n---\naliases: [{$1}]\ntags: [{$2}]\n---\n$0"),
}

luasnip.add_snippets("markdown", markdown_snippets)
