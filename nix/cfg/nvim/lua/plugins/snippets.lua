-- [[ imports ]] --------------------------------------------------------
local fmt = require("luasnip.extras.fmt").fmt
local latex_snippets = require("luasnip-latex-snippets")
local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup()

-- latex snippets
latex_snippets.setup({
	enable_autosnippets = true,
	use_treesitter = true,
	allow_on_markdown = true,
})

-- load snippets from vscode
vscode_loaders.lazy_load()

-- [[ snippets ]] --------------------------------------------------------
-- standard metadata
local metadata_template = [[
---
aliases: [{}]
tags: [{}]
---
]]

local metadata = s(
	"metadata",
	fmt(metadata_template, {
		i(1, "alias"),
		i(2, "tag"),
	})
)

-- journal entry
local journal_template = [[# {}]]

local journal = s(
	"journal",
	fmt(journal_template, {
		t(os.date("%a, %d %b %Y")),
	})
)

-- apply snippets
luasnip.add_snippets("markdown", {
	metadata,
	journal,
})
