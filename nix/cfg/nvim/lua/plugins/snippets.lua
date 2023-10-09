-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local parse_snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, {
	wordTrig = false,
})

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup({ enable_autosnippets = true })
vscode_loaders.lazy_load()

-- [[ snippets ]] --------------------------------------------------------
-- general
local metadata = parse_snippet({
	trig = "metadata",
	name = "metadata",
}, "\n---\naliases: [{}]\ntags: [{}]\n---")

local journal = parse_snippet({
	trig = "journal",
	name = "journal",
}, "# " .. os.date("%a, %d %b %Y") .. "\n")

-- apply snippets
luasnip.add_snippets("markdown", {
	metadata,
	journal,
})
