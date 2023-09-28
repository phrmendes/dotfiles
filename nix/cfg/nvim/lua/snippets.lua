-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local id = os.date("%d%m%Y%H%M%S")
local current_date = os.date("%a, %d %b %y")
local c = luasnip.choice_node
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

-- [[ snippets ]] --------------------------------------------------------
-- paper metdata
local paper_metadata_template = [[
---
title: {}
citekey: {}
tags: [{}]
id: {}
---
]]

local paper_metadata = s(
	"paperHeader",
	fmt(paper_metadata_template, {
		i(1, "title"),
		i(2, "citekey"),
		i(3, "tags"),
		t(id),
	})
)

-- standard metadata
local std_metadata_template = [[
---
title: {}
tags: [{}]
id: {}
---
]]

local std_metadata = s(
	"stdHeader",
	fmt(std_metadata_template, {
		i(1, "title"),
		i(2, "tags"),
		t(id),
	})
)

-- journal entry
local journal_entry_template = [[
# {}
]]

local journal_entry = s(
	"journalEntry",
	fmt(journal_entry_template, {
		t(current_date),
	})
)

-- task entry
local task_entry_template = [[
- [ ] [{}] {} {}
]]

local task_entry = s(
	"todoEntry",
	fmt(task_entry_template, {
		c(1, { t("#A"), t("#B"), t("#C") }),
		i(2, "task"),
		c(3, { t("due:"), t("") }),
	})
)

-- apply snippets
luasnip.add_snippets("markdown", {
	paper_metadata,
	std_metadata,
	journal_entry,
	task_entry,
})
