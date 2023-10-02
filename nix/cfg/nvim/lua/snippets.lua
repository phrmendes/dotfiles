-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

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
		t(os.date("%d-%m-%Y")),
	})
)

-- apply snippets
luasnip.add_snippets("markdown", {
	metadata,
	journal,
})
