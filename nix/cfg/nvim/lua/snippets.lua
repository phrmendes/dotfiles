-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

-- [[ snippets ]] --------------------------------------------------------
-- creating unique IDs
local generate_id = function()
	return os.date("%d%m%Y%H%M%S")
end

-- standard metadata
local metadata_template = [[
---
id: {}
aliases: [{}]
tags: [{}]
---
]]

local metadata = s(
	"metadata",
	fmt(metadata_template, {
		f(generate_id),
		i(2, "alias"),
		i(3, "tag"),
	})
)

-- journal entry
local journal_template = [[
# {}

## Tarefas
]]

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
