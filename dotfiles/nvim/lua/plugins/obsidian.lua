local obsidian = require("obsidian")
local utils = require("utils")

obsidian.setup({
	dir = vim.fn.expand("~/Documents/notes"),
	disable_frontmatter = true,
	finder = "telescope.nvim",
	follow_url_func = utils.open,
	note_id_func = utils.normalize,
	open_notes_in = "current",
	preferred_link_style = "markdown",
	sort_by = "modified",
	sort_reversed = true,
	attachments = {
		img_folder = "assets",
	},
	mappings = {
		["<CR>"] = {
			action = function()
				return obsidian.util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},
})
