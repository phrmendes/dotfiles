local template = [[
---
date: {{ date }}
---

# {{ title }}
]]

require("mkdnflow").setup({
	modules = {
		bib = false,
		buffers = true,
		conceal = true,
		cursor = true,
		folds = true,
		links = true,
		lists = true,
		maps = true,
		paths = true,
		tables = true,
		yaml = false,
		cmp = true,
	},
	new_file_template = {
		use_template = true,
		template = template,
	},
	perspective = {
		priority = "root",
		fallback = "current",
		root_tell = "index.md",
	},
	links = {
		transform_implicit = false,
		transform_explicit = require("utils").normalize,
	},
	mappings = {
		MkdnTab = false,
		MkdnSTab = false,
		MkdnEnter = { { "n", "v" }, "<CR>" },
		MkdnNextLink = { "n", "<TAB>" },
		MkdnPrevLink = { "n", "<S-TAB>" },
		MkdnNextHeading = { "n", "]]" },
		MkdnPrevHeading = { "n", "[[" },
		MkdnGoBack = { "n", "{{" },
		MkdnGoForward = { "n", "}}" },
		MkdnCreateLink = false,
		MkdnCreateLinkFromClipboard = false,
		MkdnFollowLink = false,
		MkdnDestroyLink = { "n", "<DEL>" },
		MkdnTagSpan = { "v", "<M-CR>" },
		MkdnMoveSource = { "n", "<F2>" },
		MkdnYankAnchorLink = { "n", "yaa" },
		MkdnYankFileAnchorLink = { "n", "yfa" },
		MkdnIncreaseHeading = { "n", "+" },
		MkdnDecreaseHeading = { "n", "-" },
		MkdnToggleToDo = { { "n", "v" }, "<C-CR>" },
		MkdnNewListItem = false,
		MkdnNewListItemBelowInsert = { "n", "o" },
		MkdnNewListItemAboveInsert = { "n", "O" },
		MkdnExtendList = false,
		MkdnUpdateNumbering = false,
		MkdnTableNextCell = { "i", "<TAB>" },
		MkdnTablePrevCell = { "i", "<S-TAB>" },
		MkdnTableNextRow = false,
		MkdnTablePrevRow = { "i", "<M-CR>" },
		MkdnTableNewRowBelow = { "n", "gyr" },
		MkdnTableNewRowAbove = { "n", "gyR" },
		MkdnTableNewColAfter = { "n", "gyc" },
		MkdnTableNewColBefore = { "n", "gyC" },
		MkdnFoldSection = false,
		MkdnUnfoldSection = false,
	},
})
