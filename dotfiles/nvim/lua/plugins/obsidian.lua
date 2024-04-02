local obsidian = require("obsidian")
local utils = require("utils")

obsidian.setup({
	dir = vim.fn.expand("~/Documents/notes"),
	finder = "telescope.nvim",
	follow_url_func = utils.open,
	note_frontmatter_func = utils.metadata,
	note_id_func = utils.normalize,
	open_notes_in = "current",
	sort_by = "modified",
	sort_reversed = true,
	preferred_link_style = "markdown",
	attachments = {
		img_folder = "assets",
	},
	mappings = {
		["gf"] = {
			action = obsidian.util.gf_passthrough,
			opts = { noremap = false, expr = true, buffer = true },
		},
		["<S-CR>"] = {
			action = function()
				return obsidian.util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
	},
})
