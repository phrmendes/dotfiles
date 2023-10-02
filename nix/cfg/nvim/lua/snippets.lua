-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet

-- [[ snippets ]] --------------------------------------------------------
-- creating unique IDs
local generate_id = function()
	local bufname = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.fnamemodify(bufname, ":t:r")
	local sanitized_filename = filename:gsub("[^%w]", "")
	local parent_folder = vim.fn.fnamemodify(bufname, ":h:t")
	local include_parent_folder = parent_folder ~= "notes"
	local date = os.date("%d%m%Y%H%M%S")
	local id

	if include_parent_folder then
		id = parent_folder .. "-" .. sanitized_filename .. "-" .. date
	else
		id = sanitized_filename .. "-" .. date
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
		i(1, "aliases"),
		i(2, "tags"),
	})
)

-- apply snippets
luasnip.add_snippets("markdown", {
	metadata,
})
