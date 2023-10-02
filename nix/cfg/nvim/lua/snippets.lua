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
	local bufname = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.fnamemodify(bufname, ":t:r")
	local sanitized_filename = filename:gsub("[^%w]", "")
	local parent_folder = vim.fn.fnamemodify(bufname, ":h:t")
	local date = os.date("%d%m%Y%H%M%S")
	local id

	if parent_folder == "notes" then
		id = sanitized_filename .. "-" .. date
	elseif parent_folder == "diary" then
		id = parent_folder .. "-" .. date
	else
		id = parent_folder .. "-" .. sanitized_filename .. "-" .. date
	end

	return string.upper(id)
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
