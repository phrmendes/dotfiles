local obsidian = require("obsidian")
local notes = os.getenv("NOTES") or vim.fn.expand("~/pCloudDrive/notes")

obsidian.setup({
	dir = notes,
	finder = "telescope.nvim",
	open_notes_in = "current",
	overwrite_mappings = true,
	sort_by = "modified",
	sort_reversed = true,
	disable_frontmatter = true,
	daily_notes = {
		folder = "diary",
		date_format = "%Y-%m-%d",
		alias_format = "%a, %d %b %Y",
	},
	completion = {
		min_chars = 2,
		new_notes_location = "notes_subdir",
		nvim_cmp = true,
		prepend_note_id = false,
	},
	mappings = {
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
	},
})
